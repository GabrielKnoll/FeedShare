//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct FeedStream: View {
	private let buttonAction = { print("profile pressed") }
	@ObservedObject private var launchData: LaunchListData = LaunchListData()

	var shares = [Share]()
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack {
					ForEach(0..<shares.count) { index in
						ShareRow(share: shares[index])
							.padding()
							.background(RoundedRectangle(cornerRadius: 10)
											.fill(Color(R.color.background() ?? .white))
											.padding()
											.shadow(color: Color(R.color.dropShadow() ?? .gray),
													radius: 15,
													x: 10.0,
													y: 10.0))
					}
				}
				.navigationTitle("Dein Feed")
				.navigationBarItems(trailing:
										Button(action: buttonAction) {
											Image("profile")
												.resizable()
												.aspectRatio(contentMode: .fill)
												.frame(width: 35, height: 35, alignment: .center)
												.cornerRadius(18)
										})
			}
			.background(Color(R.color.background() ?? .gray))
			.ignoresSafeArea(edges: .bottom)
		}
	}
}

struct FeedStream_Previews: PreviewProvider {
	static var previews: some View {
		let podcast = Podcast(podcastID: "pd1", title: "Luftpost Podcast")
		let episode = Episode(id: UUID(), episodeId: "ep1", title: "Estland", duration: "01:23:05", podcast: podcast)
		let author = User(id: UUID(), userId: "ud1", handle: "John Appleseed", isViewer: false)
		let share = Share(id: UUID(),
						  shareId: "sh1",
						  message: R.string.localizable.testShareMessage(),
						  author: author,
						  episode: episode)
		FeedStream(shares: [share, share, share, share, share])
	}
}

class LaunchListData: ObservableObject {
	@Published var username: String

	init() {
		self.username = "I don't know who you are"
		loadData()
	}

	func loadData() {
		Network.shared.apollo.fetch(query: ContentViewQuery()) { result in
			switch result {
			case .success(let graphQLResult):
				if let handle = graphQLResult.data?.viewer?.user?.handle {
					self.username = handle
					print(handle)
				}
			case .failure(let error):
				print("Failure! Error: \(error)")
			}
		}
	}
}
