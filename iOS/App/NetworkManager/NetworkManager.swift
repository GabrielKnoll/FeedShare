//
//  NetworkManager.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Combine
import Foundation

public struct NetworkManager {
    public typealias FeedResponse = Deferred<Future<[Share], Error>>
    public typealias ViewerResponse = Deferred<Future<Viewer, Error>>
    
    public var feedData: (String?, Bool) -> FeedResponse
    public var createViewer: (String, String, String) -> ViewerResponse
    
    public init(
        feedData: @escaping (String?, Bool) -> FeedResponse,
        createViewer: @escaping (String, String, String) -> ViewerResponse
    ) {
        self.feedData = feedData
        self.createViewer = createViewer
    }
}
