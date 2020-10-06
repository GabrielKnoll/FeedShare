//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Logic
import NetworkManager
import SwiftUI

public struct FeedStream: View {
	@ObservedObject var viewModel: FeedStreamViewModel

	private let buttonAction = { print("profile pressed") }

	public init(viewModel: FeedStreamViewModel) {
		self.viewModel = viewModel
	}

	public var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 10) {
				Button(action: buttonAction) {
					Image("profile", bundle: Bundle(identifier: "com.feedshare.Interface"))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 35, height: 35, alignment: .center)
						.cornerRadius(18)
				}
			}.frame(height: 70)
			RefreshableScrollView(refreshing: $viewModel.loading) {
				LazyVStack {
					ForEach(viewModel.shareResults, id: \.id) { share in
						ShareRow(data: share)
							.padding(.top, 5)
							.padding(.trailing, 15)
							.padding(.leading, 15)
					}
				}
				.padding(.top, 10)
				.padding(.bottom, 25)

			}
			.background(Color(R.color.background() ?? .gray))
			.ignoresSafeArea(edges: .vertical)
		}
	}
}

struct FeedStream_Previews: PreviewProvider {
	static var previews: some View {
		FeedStream(viewModel: FeedStreamViewModel(networkManager: NetworkManager.success))
	}
}
