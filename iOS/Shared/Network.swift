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
         client: URLSessionClient)
    {
        self.store = store
        self.client = client
    }

    func interceptors<Operation: GraphQLOperation>(for _: Operation) -> [ApolloInterceptor] {
        [
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: store),
            UserManagementInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: store),
        ]
    }
}

public final class Network {
    public static let shared = Network()

    private lazy var store: ApolloStore = {
        // swiftlint:disable force_unwrapping
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first!

        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.findtruffle")
        // swiftlint:enable force_unwrapping
        let documentsURL = URL(fileURLWithPath: sharedContainerURL!.absoluteString)
        let sqliteFileURL = documentsURL.appendingPathComponent("apollo.sqlite")
        // swiftlint:disable:next force_try
        let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
        return ApolloStore(cache: sqliteCache)
    }()

    public lazy var apollo: ApolloClient = {
        let transport = RequestChainNetworkTransport(
            interceptorProvider: NetworkInterceptorProvider(store: store, client: URLSessionClient()),
            // swiftlint:disable force_unwrapping
            endpointURL: URL(string: "https://api.findtruffle.com/graphql")!
        )

        let client = ApolloClient(networkTransport: transport, store: self.store)
        client.cacheKeyForObject = { $0["id"] }
        return client
    }()
}
