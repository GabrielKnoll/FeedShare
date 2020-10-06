//
//  NetworkManager.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Combine
import Foundation

public struct NetworkManager {
	public var feedData: (String?, NMCachePolicy) -> Deferred<Future<[Share], Error>>

	public init(feedData: @escaping (String?, NMCachePolicy) -> Deferred<Future<[Share], Error>>) {
		self.feedData = feedData
	}
}

public enum NMCachePolicy {
	case fetchIgnoringCacheData
	case returnCacheDataAndFetch
}
