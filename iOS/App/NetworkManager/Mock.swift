//
//  Mock.swift
//  NetworkManager
//
//  Created by Gabriel Knoll on 04.10.20.
//

import Combine
import Foundation

extension NetworkManager {

	public static let success = Self(
		feedData: {
			return Future { promise in
				promise(.success([MockShares.mockPodcast(), MockShares.mockEpisode()]))
			}
		}
	)
}

private struct MockShares {

	static func mockPodcast() -> Share {
		let mockAuthor = Author(handle: "gabriel",
								displayName: "Gabriel Knoll",
								profilePicture: URL(string: "https://pbs.twimg.com/profile_images/1216776408984363010/a9zddy5o_400x400.jpg"))
		let mockPodcast = Podcast(title: "Luftpost",
								  artwork: "https://luftpost-podcast.de/cover.png",
								  description: "Spannende Länder, interessante Leute, tolle Geschichten.",
								  publisher: "Daniel Büchele")
		let mockAttachment = Attachment(title: "Luftpost Podcast", artwork: "https://luftpost-podcast.de/cover.png", episode: nil, podcast: mockPodcast)
		return Share(author: mockAuthor, message: "Check out this podcast!", createdAt: "04.10.2020", attachment: mockAttachment)
	}

	static func mockEpisode() -> Share {
		let mockAuthor = Author(handle: "gabriel",
								displayName: "Gabriel Knoll",
								profilePicture: URL(string: "https://pbs.twimg.com/profile_images/1216776408984363010/a9zddy5o_400x400.jpg"))
		//		let mockPodcast = Podcast(title: "Luftpost",
		//artwork: "https://luftpost-podcast.de/cover.png", description: "Spannende Länder, interessante Leute, tolle Geschichten.",
		//publisher: "Daniel Büchele")
		let mockEpisode = Episode(title: "Senegal",
								  artwork: "https://luftpost-podcast.de/senegal/",
								  durationSeconds: 3_820,
								  description: "Sie erzählt von der Gastfreundschaft und viel zu viel Essen& Ausflüge in die Wüste",
								  podcast: "Luftpost Podcast")
		let mockAttachment = Attachment(title: "Luftpost | Senegal", artwork: "https://luftpost-podcast.de/cover.png", episode: mockEpisode, podcast: nil)
		return Share(author: mockAuthor, message: "Check out this episode of Luftpost Podcast", createdAt: "04.10.2020", attachment: mockAttachment)
	}
}
