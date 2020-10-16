//
//  FeedStreamViewModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import NetworkManager

public class FeedStreamViewModel: ObservableObject {
	@Published public var shareResults = [Share]()
	@Published public var loading = false {
		didSet {
			if oldValue == false && loading == true {
				loadAfterCursor()
			}
		}
	}

	private let networkManager: NetworkManager

	var feedRequestCancellable: AnyCancellable?

	public init(networkManager: NetworkManager) {
		self.networkManager = networkManager
		loadData(after: nil)
	}

	private func loadAfterCursor() {
		let cursor = networkManager.cursor()
		loadData(after: cursor, policy: .fetchIgnoringCacheData)
	}

	private func loadData(after: String?, policy: NMCachePolicy = .returnCacheDataAndFetch) {
		if !loading { loading = true }
		feedRequestCancellable = networkManager
			.feedData(after, policy)
			.sink(receiveCompletion: { _ in },
				  receiveValue: { [weak self] shares in
					guard let self = self else { return }
					self.shareResults = shares
					self.loading = false
				  })
	}
}
