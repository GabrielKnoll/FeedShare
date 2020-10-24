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
    
    public var feedData: (String?, Bool) -> NetworkData
    
    public init(feedData: @escaping (String?, Bool) -> NetworkData) {
        self.feedData = feedData
    }
}
