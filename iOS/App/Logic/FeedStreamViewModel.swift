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

	var feedRequestCancellable: AnyCancellable?

	public init(networkManager: NetworkManager) {
		feedRequestCancellable = networkManager
			.feedData()
			.sink(receiveCompletion: { _ in },
				  receiveValue: { [weak self] shares in
					guard let self = self else { return }
					self.shareResults = shares })
	}
}
