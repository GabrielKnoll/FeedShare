//
//  Share.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 30.09.20.
//

import Foundation

public struct Share: Identifiable {

	public init(author: Author, message: String?, createdAt: String, attachment: Attachment?, cursor: String?) {
		self.author = author
		self.message = message
		self.createdAt = createdAt
		self.attachment = attachment
		self.cursor = cursor
	}

	public let id = UUID()
	public let author: Author
	public let message: String?
	public let createdAt: String
	public let attachment: Attachment?
	public let cursor: String?

}

public struct Author {
	public init(handle: String, displayName: String, profilePicture: URL?) {
		self.handle = handle
		self.displayName = displayName
		self.profilePicture = profilePicture
	}

	public let handle: String
	public let displayName: String
	public let profilePicture: URL?
}

public struct Attachment {
	public init(title: String, artwork: String?, episode: Episode?, podcast: Podcast?) {
		self.title = title
		self.artwork = artwork
		self.episode = episode
		self.podcast = podcast
	}

	public let title: String
	public let artwork: String?
	public let episode: Episode?
	public let podcast: Podcast?
}

public struct Episode {
	public init(title: String, artwork: String?, durationSeconds: Int?, description: String?, podcast: String) {
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
	public let podcast: String
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
