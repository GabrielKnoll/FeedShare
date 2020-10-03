//
//  NetworkManagerLive.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Apollo
import Foundation
import NetworkManager

extension NetworkManager {
	public static let live = Self(
		launchListData: { fetch() })
}

private func fetch() -> [Share] {
	var results = [Share]()
	Network.shared.apollo.fetch(query: FeedStreamQuery()) { result in
		switch result {
		case .success(let graphQLResult):
			results = parseResults(results: graphQLResult.data?.shares.edges ?? [])
		case .failure(let error):
			assertionFailure("Failure! Error: \(error)")
		}
	}
	return results
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
		let share = Share(author: author, message: fragment.message, createdAt: fragment.createdAt, attachment: attachment)
		shares.append(share)
	}
	return shares
}
