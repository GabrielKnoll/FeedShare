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
				loadData(before: shareResults.first?.cursor, policy: .fetchIgnoringCacheData)
			}
		}
	}

	private let networkManager: NetworkManager

	var feedRequestCancellable: AnyCancellable?

	public init(networkManager: NetworkManager) {
		self.networkManager = networkManager
		loadData(before: nil)
	}

	private func loadData(before: String?, policy: NMCachePolicy = .returnCacheDataAndFetch) {
		if !loading { loading = true }
		feedRequestCancellable = networkManager
			.feedData(before, policy)
			.sink(receiveCompletion: { _ in },
				  receiveValue: { [weak self] shares in
					guard let self = self else { return }
					self.shareResults = shares
					self.loading = false
				  })
	}
}
