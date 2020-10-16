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
		feedData: { after, policy in
			return Deferred { Future<[Share], Error> { promise in
				Network.shared.apollo.fetch(query: FeedStreamQuery(after: after), cachePolicy: cachePolicy(policy)) { result in
					switch result {
					case .success(let graphQLResult):
						let data = (graphQLResult.data?.shares.edges as? [FeedStreamQuery.Data.Share.Edge])
						promise(.success(parseResults(results: data ?? [])))
					case .failure(let error):
						assertionFailure("Failure! Error: \(error)")
						promise(.failure(error))
					}
				}
			}
			}
		},
		cursor: { () -> String? in
			var data: FeedStreamQuery.Data?
			Network.shared.apollo.store.withinReadTransaction({ transaction in
				data = try? transaction.read(query: FeedStreamQuery())
			})
			return data?.shares.pageInfo?.endCursor
		}
)

}

private func cachePolicy(_ policy: NMCachePolicy) -> CachePolicy {
	switch policy {
	case .fetchIgnoringCacheData:
		return .fetchIgnoringCacheData
	case .returnCacheDataAndFetch:
		return .returnCacheDataAndFetch
	}
}

private func parseResults(results: [FeedStreamQuery.Data.Share.Edge]) -> [Share] {
	var shares = [Share]()
	for result in results {
		guard let fragment = result.node?.fragments.shareFragment,
			  let attachmentFragment = fragment.attachment?.fragments.attachmentFragment else { continue }

		var podcast: Podcast?
		var episode: Episode?

		let author = Author(handle: fragment.author.handle,
							displayName: fragment.author.displayName,
							profilePicture: URL(string: fragment.author.profilePicture ?? ""))

		if let podAttachment = attachmentFragment.asPodcast {
			podcast = Podcast(title: podAttachment.title,
							  artwork: podAttachment.artwork,
							  description: podAttachment.description,
							  publisher: podAttachment.publisher)
		}

		if let epAttachment = attachmentFragment.asEpisode {
			episode = Episode(title: epAttachment.title,
							  artwork: epAttachment.artwork,
							  durationSeconds: epAttachment.durationSeconds,
							  description: epAttachment.description,
							  podcast: epAttachment.podcast.title)
		}

		let attachment = Attachment(title: attachmentFragment.title, artwork: attachmentFragment.artwork, episode: episode, podcast: podcast)
		let share = Share(author: author, message: fragment.message, createdAt: fragment.createdAt, attachment: attachment, cursor: result.cursor)
		shares.append(share)
	}
	return shares
}
