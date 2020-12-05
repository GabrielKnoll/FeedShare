//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation

public class ComposerModel: ObservableObject {
    @Published public var searchResults: [ComposerPodcastFragment]?
    @Published public var latestEpisodes = [EpisodeAttachmentFragment]()
    @Published public var episode: EpisodeAttachmentFragment?
    @Published public var podcast: ComposerPodcastFragment?
    @Published public var isSearching: Bool = false
    @Published public var isResolving: Bool = false
    
    func resolveUrl(url: String) {
        self.isResolving = true
        Network.shared.apollo.fetch(query: ResolveQuery(url: url),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isResolving = false
            switch result {
            case let .success(graphQLResult):
                self.episode = graphQLResult.data?.resolveShareUrl?.episode?.fragments.episodeAttachmentFragment
                if self.episode == nil {
                    self.podcast = graphQLResult.data?.resolveShareUrl?.podcast?.fragments.composerPodcastFragment
                    self.latestEpisodes = graphQLResult.data?.resolveShareUrl?.podcast?.latestEpisodes?.compactMap {
                        $0?.fragments.episodeAttachmentFragment
                    } ?? []
                }
            case .failure:
                self.episode = nil
                self.podcast = nil
                self.latestEpisodes = []
            }
        }
    }
    
    func findPodcast(searchText: String) {
        print(searchText)
        self.isSearching = true
        Network.shared.apollo.fetch(query: FindPodcastQuery(query: searchText),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isSearching = false
            switch result {
            case let .success(graphQLResult):
                self.searchResults = graphQLResult.data?.findPodcast?.compactMap {
                    $0?.fragments.composerPodcastFragment
                } ?? []
            case .failure:
                self.searchResults = nil
            }
        }
    }
}
