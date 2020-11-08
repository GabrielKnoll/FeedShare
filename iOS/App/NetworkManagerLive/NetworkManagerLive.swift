//
//  NetworkManagerLive.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Apollo
import Combine
import Foundation
import NetworkManager

extension NetworkManager {
    public static let live = Self(
        feedData: { after, fetchNew in
            let cachePolicy = fetchNew ? CachePolicy.fetchIgnoringCacheCompletely : CachePolicy.returnCacheDataAndFetch
            
            return Deferred { Future<[Share], Error> { promise in
                Network.shared.apollo.fetch(query: FeedStreamQuery(after: after), cachePolicy: cachePolicy) { result in
                    switch result {
                    case .success(let graphQLResult):
                        let data = (graphQLResult.data?.shares.edges as? [FeedStreamQuery.Data.Share.Edge]) ?? []
                        
                        if fetchNew {
                            // manually append to cache
                            Network.shared.apollo.store.withinReadWriteTransaction({ transaction in
                                try transaction.update(query: FeedStreamQuery()) { (cache: inout FeedStreamQuery.Data) in
                                    cache.shares.edges?.append(contentsOf: data)
                                }
                            })
                        }
                        
                        promise(.success(parseResults(results: data)))
                    case .failure(let error):
                        assertionFailure("Failure! Error: \(error)")
                        promise(.failure(error))
                    }
                }
            }
            }
        },
        createViewer: {twitterId, twitterToken, twitterTokenSecret in
            return Deferred { Future<Viewer, Error> { promise in
                Network.shared.apollo.perform(mutation: CreateViewerMutation(
                    twitterId: twitterId,
                    twitterToken: twitterToken,
                    twitterTokenSecret: twitterTokenSecret
                )) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let viewer = graphQLResult.data?.createViewer {
                            
                            var pic: URL?
                            if let profilePicture = viewer.fragments.viewerFragment.user.profilePicture {
                                pic = URL(string: profilePicture)
                            }
                            
                            let user = User(
                                handle: viewer.fragments.viewerFragment.user.handle,
                                displayName: viewer.fragments.viewerFragment.user.displayName,
                                profilePicture: pic)
                            promise(.success(Viewer(
                                                id: viewer.fragments.viewerFragment.user.id,
                                                token: viewer.fragments.viewerFragment.token,
                                                user: user)))
                        } else {
                            
                        }
                    case .failure(let error):
                        assertionFailure("Failure! Error: \(error)")
                        promise(.failure(error))
                    }
                }
            }
            }
        }
    )
}

private func parseResults(results: [FeedStreamQuery.Data.Share.Edge]) -> [Share] {
    var shares = [Share]()
    for result in results {
        guard let fragment = result.node?.fragments.shareFragment else { continue }
        
        let author = User(handle: fragment.author.handle,
                          displayName: fragment.author.displayName,
                          profilePicture: URL(string: fragment.author.profilePicture ?? ""))
        
        let podcast = Podcast(title: fragment.episode.fragments.episodeFragment.podcast.title,
                              artwork: nil,
                              description: fragment.episode.fragments.episodeFragment.podcast.description,
                              publisher: fragment.episode.fragments.episodeFragment.podcast.publisher)
        
        let episode = Episode(title: fragment.episode.fragments.episodeFragment.title,
                              artwork: fragment.episode.fragments.episodeFragment.artwork,
                              durationSeconds: fragment.episode.fragments.episodeFragment.durationSeconds,
                              description: fragment.episode.fragments.episodeFragment.description,
                              podcast: podcast)
        
        let share = Share(author: author, message: fragment.message, createdAt: fragment.createdAt, episode: episode, cursor: result.cursor)
        shares.append(share)
    }
    return shares
}
