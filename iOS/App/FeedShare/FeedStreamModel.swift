//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation

public class FeedStreamModel: ObservableObject {
    @Published public var shares = [FeedStreamModelQuery.Data.Share.Edge]()
    @Published public var loading = false {
        didSet {
            if !oldValue, loading, initialized {
                loadData(after: shares.last?.cursor)
            }
        }
    }

    private var initialized = false

    public init() {
        initializeFromCache()
    }

    private func initializeFromCache() {
        Network.shared.apollo.fetch(query: FeedStreamModelQuery(),
                                    cachePolicy: .returnCacheDataDontFetch) { result in
            switch result {
            case let .success(graphQLResult):
                let data = (graphQLResult.data?.shares.edges as? [FeedStreamModelQuery.Data.Share.Edge]) ?? []
                self.shares.append(contentsOf: data)
                // check for new results
                self.loadData(after: data.last?.cursor)
            case let .failure(error):
                print("initializeFromCache Failure! Error: \(error)")
                self.loadData()
            }
        }
    }

    private func loadData(after: String? = nil) {
        if !loading { loading = true }
        Network.shared.apollo.fetch(query: FeedStreamModelQuery(after: after),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { result in

            self.loading = false
            switch result {
            case let .success(graphQLResult):
                let contents = (graphQLResult.data?.shares.edges as? [FeedStreamModelQuery.Data.Share.Edge]) ?? []
                // manually uodate to cache
                Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    do {
                        // append to cache
                        try transaction.update(query: FeedStreamModelQuery()) { (cache: inout FeedStreamModelQuery.Data) in
                            cache.shares.edges?.append(contentsOf: contents)
                        }
                    } catch {
                        // create cache
                        try transaction.write(data: graphQLResult.data!, forQuery: FeedStreamModelQuery())
                    }
                }

                self.shares.append(contentsOf: contents)
                self.initialized = true
            case let .failure(error):
                print("loadData Failure! Error: \(error)")
            }
        }
    }
}
