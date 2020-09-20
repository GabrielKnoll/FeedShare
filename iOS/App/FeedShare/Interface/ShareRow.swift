//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct ShareRow: View {
	let share: Share
	private let buttonAction = { print("button pressed") }
	var body: some View {
		VStack(alignment: .leading) {
			Spacer()
			HStack(alignment: .center, spacing: 15) {
				Image("profile")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30, height: 30, alignment: .center)
					.cornerRadius(15)
				Text(share.author.handle)
					.font(.headline)
				Spacer()
				Button(action: buttonAction) {
					Image(systemName: "ellipsis")
				}
				.padding()
				.foregroundColor(.black)
				.font(.headline)

			}
			Text(share.message)
			HStack(alignment: .center, spacing: 15) {
				Image("logo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 55, height: 55, alignment: .center)
					.cornerRadius(15)
				VStack(alignment: .leading, spacing: 3) {
					Text(share.episode.title)
						.font(.headline)
					Text(share.episode.podcast.title)
						.font(.subheadline)
						.foregroundColor(.secondary)
					HStack {
						Image(systemName: "clock")
						Text(share.episode.duration)
					}
					.foregroundColor(.secondary)
					.font(.caption)
				}
				Spacer()
			}
			Spacer()
		}
		.padding()
	}
}

struct ShareRow_Previews: PreviewProvider {
	static var previews: some View {
		let podcast = Podcast(podcastID: "pd1", title: "Luftpost Podcast")
		let episode = Episode(id: UUID(), episodeId: "ep1", title: "Estland", duration: "01:23:05", podcast: podcast)
		let author = User(id: UUID(), userId: "ud1", handle: "John Appleseed", isViewer: false)
		let share = Share(id: UUID(),
						  shareId: "sh1",
						  message: R.string.localizable.testShareMessage(),
						  author: author,
						  episode: episode)
		ShareRow(share: share)
	}
}
