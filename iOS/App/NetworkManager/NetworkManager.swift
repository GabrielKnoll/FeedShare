//
//  NetworkManager.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Combine
import Foundation

public struct NetworkManager {
	public typealias NetworkData = Deferred<Future<[Share], Error>>

	public var feedData: (String?, NMCachePolicy) -> NetworkData
	public var cursor: () -> String?

	public init(feedData: @escaping (String?, NMCachePolicy) -> NetworkData, cursor: @escaping () -> String?) {
		self.feedData = feedData
		self.cursor = cursor
	}
}

public enum NMCachePolicy {
	case fetchIgnoringCacheData
	case returnCacheDataAndFetch
}
