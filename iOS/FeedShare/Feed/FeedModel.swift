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

public enum FeedType {
    case Global
    case Personal
//    case User(String)
}

public class FeedModel: ObservableObject {
    private static var instances = [FeedType: FeedModel]()
    
    @Published public var shares = [ShareConnectionFragment.Edge]()
    @Published public var loading = false {
        didSet {
            if !oldValue, loading {
                loadData(after: shares.last?.cursor)
            }
        }
    }
    
    private var loadRequest: Apollo.Cancellable?
    private let feedType: FeedType
    private var reloadObserver: NSObjectProtocol?
    private var logoutObserver: NSObjectProtocol?
    public var initialized = false
    
    class func shared(_ type: FeedType) -> FeedModel {
        guard let instance = instances[type] else {
            let instance = FeedModel(type: type)
            instances.updateValue(instance, forKey: type)
            return instance
        }
        return instance
    }
    
    class func destroy(_ type: FeedType) {
        instances.removeValue(forKey: type)
    }
    
    public init(type: FeedType) {
        feedType = type
        initializeFromCache()
        reloadObserver = NotificationCenter.default.addObserver(forName: .reloadFeed, object: nil, queue: .main) { notification in
            if let share = notification.object as? ShareFragment, let index = self.shares.firstIndex(where: { $0.node?.id == share.id }) {
                self.shares[index].node?.fragments.shareFragment = share
            }
            self.loading = true
        }
        logoutObserver = NotificationCenter.default.addObserver(forName: .logoutFeed, object: nil, queue: .main) { _ in
            FeedModel.instances.removeValue(forKey: type)
        }
    }
    
    deinit {
        if let observer = self.reloadObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self.logoutObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func initializeFromCache() {
        if let lr = loadRequest {
            lr.cancel()
        }
        loadRequest = Network.shared.apollo.fetch(query: GlobalFeedQuery(),
                                                  cachePolicy: .returnCacheDataDontFetch) { result in
            switch result {
            case let .success(graphQLResult):
                let data = (graphQLResult.data?.globalFeed.fragments.shareConnectionFragment.edges as? [ShareConnectionFragment.Edge]) ?? []
                self.shares.append(contentsOf: data)
                if !self.shares.isEmpty {
                    self.initialized = true
                }
                self.loading = true
            case .failure:
                self.loading = true
            }
        }
    }
    
    private func loadData(after: String? = nil) {
        if let lr = loadRequest {
            lr.cancel()
        }
        let startTime = DispatchTime.now()
        
        loadRequest = Network.shared.apollo.fetch(query: GlobalFeedQuery(after: after),
                                                  cachePolicy: .fetchIgnoringCacheCompletely) { result in
            
            DispatchQueue.main.asyncAfter(deadline: startTime + 1.5) {
                self.loading = false
            }
            
            switch result {
            case let .success(graphQLResult):
                let contents = (graphQLResult.data?.globalFeed.fragments.shareConnectionFragment.edges as? [ShareConnectionFragment.Edge]) ?? []
                
                // manually uodate to cache
                Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    do {
                        // append to cache
                        try transaction.update(query: GlobalFeedQuery()) { (cache: inout GlobalFeedQuery.Data) in
                            cache.globalFeed.fragments.shareConnectionFragment.edges?.append(contentsOf: contents)
                        }
                    } catch {
                        if let data = graphQLResult.data {
                            // create cache
                            try transaction.write(
                                data: data,
                                forQuery: GlobalFeedQuery()
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
    
    public static func addToPersonalFeed(id: String, callback: @escaping (ShareFragment?) -> Void) {
        Network.shared.apollo.perform(mutation: AddToPersonalFeedMutation(id: id)) { result in
            switch result {
            case let .success(graphQLResult):
                if let share = graphQLResult.data?.addToPersonalFeed?.fragments.shareFragment {
                    NotificationCenter.default.post(name: .reloadFeed, object: graphQLResult.data?.addToPersonalFeed?.fragments.shareFragment)
                    return callback(share)
                }
            case let .failure(error):
                print("addToPersonalFeed Failure! Error: \(error)")
                
            }
            
            callback(nil)
        }
    }
}
