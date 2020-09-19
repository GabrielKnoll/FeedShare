//
//  Models.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Foundation

struct Share: Identifiable {
	let id: UUID
	let shareId: String
	let message: String
	let author: User
	let episode: Episode
}

struct User: Identifiable {
	let id: UUID
	let userId: String
	let handle: String
	let isViewer: Bool
}

struct Episode: Identifiable {
	let id: UUID
	let episodeId: String
	let title: String
	let podcast: Podcast
}

struct Podcast {
	let podcastID: String
	let title: String
}

struct Viewer {
	let user: User
	let personalFeed: String
}
