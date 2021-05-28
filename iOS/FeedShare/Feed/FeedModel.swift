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

public enum FeedType: Hashable {
    case Global
    case Personal
    case User(id: String)
}

extension FeedType: Equatable {
    public static func == (lhs: FeedType, rhs: FeedType) -> Bool {
        switch (lhs, rhs) {
        case (.Global, .Global), (.Personal, .Personal):
            return true
        case (.User(let id1), .User(let id2)):
            return id1 == id2
        default:
            return false
        }
    }
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
        
        let cachePolicy = CachePolicy.returnCacheDataDontFetch
        
        loadRequest = {
            switch self.feedType {
            case .Global:
                return Network.shared.apollo.fetch(
                    query: GlobalFeedQuery(),
                    cachePolicy: cachePolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        self.initializeFromCacheDone(data: graphQLResult.data?.globalFeed.fragments.shareConnectionFragment)
                    case .failure:
                        self.initializeFromCacheDone()
                    }
                }
            case .Personal:
                return Network.shared.apollo.fetch(
                    query: PersonalFeedQuery(),
                    cachePolicy: cachePolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        self.initializeFromCacheDone(data: graphQLResult.data?.viewer?.personalFeed.fragments.shareConnectionFragment)
                    case .failure:
                        self.initializeFromCacheDone()
                    }
                }
            case .User(let id):
                return Network.shared.apollo.fetch(
                    query: UserFeedQuery(userId: id),
                    cachePolicy: cachePolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        self.initializeFromCacheDone(data: graphQLResult.data?.node?.asUser?.feed.fragments.shareConnectionFragment)
                    case .failure:
                        self.initializeFromCacheDone()
                    }
                }
            }
        }()
    }
    
    private func initializeFromCacheDone(data: ShareConnectionFragment? = nil) {
        if let edges = data?.edges {
            self.shares.append(contentsOf: edges.compactMap { $0 })
            if !self.shares.isEmpty {
                self.initialized = true
            }
        }
        self.loading = true
    }
    
    private func loadData(after: String? = nil) {
        if let lr = loadRequest {
            lr.cancel()
        }
        let startTime = DispatchTime.now()
        let cachPolicy = CachePolicy.fetchIgnoringCacheCompletely
        
        loadRequest = {
            switch self.feedType {
            case .Global:
                return Network.shared.apollo.fetch(
                    query: GlobalFeedQuery(after: after),
                    cachePolicy: cachPolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        let edges = graphQLResult.data?.globalFeed.fragments.shareConnectionFragment.edges?.compactMap({ $0 })
                        self.loadDataDone(startTime, data: edges)
                        
                        if let nonNullEdges = edges {
                            // manually update to cache
                            Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                                do {
                                    // append to cache
                                    try transaction.update(query: GlobalFeedQuery()) { (cache: inout GlobalFeedQuery.Data) in
                                        cache.globalFeed.fragments.shareConnectionFragment.edges?.append(contentsOf: nonNullEdges)
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
                        }
                    case .failure:
                        self.loadDataDone(startTime)
                    }
                }
            case .Personal:
                return Network.shared.apollo.fetch(
                    query: PersonalFeedQuery(after: after),
                    cachePolicy: cachPolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        let edges = graphQLResult.data?.viewer?.personalFeed.fragments.shareConnectionFragment.edges?.compactMap({ $0 })
                        
                        self.loadDataDone(startTime, data: edges)
                        
                        if let nonNullEdges = edges {
                            // manually update to cache
                            Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                                do {
                                    // append to cache
                                    try transaction.update(query: PersonalFeedQuery()) { (cache: inout PersonalFeedQuery.Data) in
                                        cache.viewer?.personalFeed.fragments.shareConnectionFragment.edges?.append(contentsOf: nonNullEdges)
                                    }
                                } catch {
                                    if let data = graphQLResult.data {
                                        // create cache
                                        try transaction.write(
                                            data: data,
                                            forQuery: PersonalFeedQuery()
                                        )
                                    }
                                }
                            }
                        }
                    case .failure:
                        self.loadDataDone(startTime)
                    }
                }
            case .User(let id):
                return Network.shared.apollo.fetch(
                    query: UserFeedQuery(after: after, userId: id),
                    cachePolicy: cachPolicy
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        // not caching results for individual users
                        self.loadDataDone(startTime, data: graphQLResult.data?.node?.asUser?.feed.fragments.shareConnectionFragment.edges?.compactMap({ $0 }))
                    case .failure:
                        self.loadDataDone(startTime)
                    }
                }
            }
        }()
    }
    
    private func loadDataDone(_ startTime: DispatchTime, data: [ShareConnectionFragment.Edge]? = nil) {
        DispatchQueue.main.asyncAfter(deadline: startTime + 1.5) {
            self.loading = false
        }
        if let edges = data {
            self.shares.append(contentsOf: edges)
        }
        self.initialized = true
    }
    
    public static func addToPersonalFeed(id: String, callback: @escaping (ShareFragment?) -> Void) {
        Network.shared.apollo.perform(mutation: AddToPersonalFeedMutation(id: id)) { result in
            switch result {
            case let .success(graphQLResult):
                if let share = graphQLResult.data?.addToPersonalFeed?.fragments.shareFragment {
                    NotificationCenter.default.post(
                        name: .reloadFeed,
                        object: graphQLResult.data?.addToPersonalFeed?.fragments.shareFragment
                    )
                    return callback(share)
                }
            case let .failure(error):
                print("addToPersonalFeed Failure! Error: \(error)")
                
            }
            
            callback(nil)
        }
    }
}
