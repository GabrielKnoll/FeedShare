//
//  Network.swift
//  FeedShare
//
//  Created by Daniel Büchele on 9/19/20.
//

import Apollo
import ApolloSQLite
import Foundation

struct NetworkInterceptorProvider: InterceptorProvider {
    
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: self.store),
            UserManagementInterceptor(),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: self.store)
        ]
    }
}

final class Network {
    static let shared = Network()
    
    private lazy var store: ApolloStore = {
        //swiftlint:disable force_unwrapping
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first!
        //swiftlint:enable force_unwrapping
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("apollo.sqlite")
        // swiftlint:disable:next force_try
        let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
        return ApolloStore(cache: sqliteCache)
    }()
    
    private(set) lazy var apollo: ApolloClient = {
        let transport = RequestChainNetworkTransport(
            interceptorProvider: NetworkInterceptorProvider(store: store, client: URLSessionClient()),
            //swiftlint:disable force_unwrapping
            endpointURL: URL(string: "https://feed.buechele.cc/graphql")!
        )
        
        let client = ApolloClient(networkTransport: transport, store: self.store)
        client.cacheKeyForObject = { $0["id"] }
        return client
    }()
}
