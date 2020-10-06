//
//  NetworkManager.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Combine
import Foundation

public struct NetworkManager {
	public var feedData: () -> Deferred<Future<[Share], Error>>

	public init(feedData: @escaping () -> Deferred<Future<[Share], Error>>) {
		self.feedData = feedData
	}
}
