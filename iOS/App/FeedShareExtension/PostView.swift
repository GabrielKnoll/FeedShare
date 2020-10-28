//
//  PostView.swift
//  FeedShareExtension
//
//  Created by Gabriel Knoll on 19.10.20.
//

import Interface
import NetworkManager
import SwiftUI
import URLImage

struct PostView: View {
	
	var data: Share {
		let mockAuthor = Author(handle: "gabriel",
								displayName: "Gabriel Knoll",
								profilePicture: URL(string: "https://pbs.twimg.com/profile_images/1216776408984363010/a9zddy5o_400x400.jpg"))
		let mockEpisode = Episode(title: "Senegal",
								  artwork: "https://luftpost-podcast.de/senegal/",
								  durationSeconds: 3_820,
								  description: "Sie erzählt von der Gastfreundschaft und viel zu viel Essen& Ausflüge in die Wüste",
								  podcast: "Luftpost Podcast")
		let mockAttachment = Attachment(title: "Luftpost | Senegal", artwork: "https://luftpost-podcast.de/cover.png", episode: mockEpisode, podcast: nil)
		return Share(author: mockAuthor,
					 message: "Check out this episode of Luftpost Podcast",
					 createdAt: "04.10.2020",
					 attachment: mockAttachment,
					 cursor: nil)
	}
	
	@State private var shareText: String = "What did you like about this episode?"

	var body: some View {
		ShareRow(data: data, isEditable: true)
	}
}

struct PostView_Previews: PreviewProvider {
	static var previews: some View {
		PostView()
	}
}
