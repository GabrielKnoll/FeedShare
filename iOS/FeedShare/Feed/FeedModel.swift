//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Apollo
import Combine
import Foundation
import Shared

public class FeedModel: ObservableObject {
    
    public static let personal = FeedModel(type: .personal)
    public static let global = FeedModel(type: .global)
    public static let user = FeedModel(type: .user)
    
    @Published public var shares = [FeedQuery.Data.Share.Edge]()
    @Published public var loading = false {
        didSet {
            if !oldValue, loading {
                loadData(after: shares.last?.cursor)
            }
        }
    }
    private var loadRequest: Apollo.Cancellable?
    private let feedType: FeedType
    private var observer: NSObjectProtocol?
    public var initialized = false
    
    public init(type: FeedType) {
        print("init feed \(type)")
        feedType = type
        initializeFromCache()
        self.observer = NotificationCenter.default.addObserver(forName: .reloadFeed, object: nil, queue: .main) { _ in
            // maybe use share from argument _
            //self.loadData(after: self.shares.last?.cursor)
            print("notif")
            self.loading = true
        }
    }
    
    deinit {
        print("deinit")
        if let o = self.observer {
            print("removeObserver")
            NotificationCenter.default.removeObserver(o)
        }
    }
    
    private func initializeFromCache() {
        if let lr = self.loadRequest {
            lr.cancel()
        }
        loadRequest = Network.shared.apollo.fetch(query: FeedQuery(feedType: feedType),
                                    cachePolicy: .returnCacheDataDontFetch) { result in
            switch result {
            case let .success(graphQLResult):
                let data = (graphQLResult.data?.shares.edges as? [FeedQuery.Data.Share.Edge]) ?? []
                self.shares.append(contentsOf: data)
                if !self.shares.isEmpty {
                    self.initialized = true
                }
                // check for new results
                //self.loadData(after: data.last?.cursor)
                self.loading = true
            case .failure:
                // self.loadData()
                self.loading = true
            }
        }
    }
    
    private func loadData(after: String? = nil) {
        // if !loading { loading = true }
        if let lr = self.loadRequest {
            lr.cancel()
        }
        let startTime = DispatchTime.now()
        
        print("after \(after) \(self.feedType)")
        
        loadRequest = Network.shared.apollo.fetch(query: FeedQuery(after: after, feedType: feedType),
                                                  cachePolicy: .fetchIgnoringCacheCompletely) { result in
            
            DispatchQueue.main.asyncAfter(deadline: startTime + 1.5) {
                self.loading = false
            }
            
            switch result {
            case let .success(graphQLResult):
                let contents = (graphQLResult.data?.shares.edges as? [FeedQuery.Data.Share.Edge]) ?? []
                // manually uodate to cache
                Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    do {
                        // append to cache
                        try transaction.update(query: FeedQuery(feedType: self.feedType)) { (cache: inout FeedQuery.Data) in
                            print("append \(self.feedType) \(contents.first?.cursor) \(after)")
                            cache.shares.edges?.append(contentsOf: contents)
                        }
                    } catch {
                        if let data = graphQLResult.data {
                            // create cache
                            try transaction.write(
                                data: data,
                                forQuery: FeedQuery(feedType: self.feedType)
                            )
                        }
                    }
                }
                
                self.shares.append(contentsOf: contents)
                
            case let .failure(error):
                print("loadData Failure! Error: \(error)")
            }
            self.initialized = true
        }
    }
}
