//
//  Share.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 30.09.20.
//

import Foundation

public struct Share: Identifiable {

	public init(author: User, message: String?, createdAt: String, episode: Episode, cursor: String?) {
		self.author = author
		self.message = message
		self.createdAt = createdAt
		self.episode = episode
		self.cursor = cursor
	}

	public let id = UUID()
	public let author: User
	public let message: String?
	public let createdAt: String
	public let episode: Episode
	public let cursor: String?

}

public struct Viewer: Codable {
    public init(id: String, token: String, user: User) {
        self.token = token
        self.id = id
        self.user = user
    }

    public let id: String
    public let user: User
    public let token: String
}

public struct User: Codable {
	public init(handle: String, displayName: String?, profilePicture: URL?) {
		self.handle = handle
		self.displayName = displayName
		self.profilePicture = profilePicture
	}

	public let handle: String
	public let displayName: String?
	public let profilePicture: URL?
}

public struct Episode {
	public init(title: String, artwork: String?, durationSeconds: Int?, description: String?, podcast: Podcast) {
		self.title = title
		self.artwork = artwork
		self.durationSeconds = durationSeconds
		self.description = description
		self.podcast = podcast
	}

	public let title: String
	public let artwork: String?
	public let durationSeconds: Int?
	public let description: String?
	public let podcast: Podcast
}

public struct Podcast {
	public init(title: String, artwork: String?, description: String?, publisher: String) {
		self.title = title
		self.artwork = artwork
		self.description = description
		self.publisher = publisher
	}

	public let title: String
	public let artwork: String?
	public let description: String?
	public let publisher: String
}
