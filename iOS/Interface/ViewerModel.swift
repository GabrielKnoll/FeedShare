//
//  FeedStreamViewModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import Network

public class ViewerModel: ObservableObject {
    public static let shared = ViewerModel()
    
    @Published public var podcastClients = [Client]()
    
    @Published public var viewerClient: Client? = {
        if let resultMap = UserDefaults.standard.dictionary(forKey: "ViewerClient") {
            return Client(unsafeResultMap: resultMap)
        }
        return nil
    }() {
        didSet {
            UserDefaults.standard.set(viewerClient?.jsonObject, forKey: "ViewerClient")
        }
    }
    
    @Published public var viewer: ViewerFragment?
    @Published public var initialized: Bool = false
    @Published public var setupFinshed: Bool = UserDefaults.standard.bool(forKey: "setupFinished") {
        didSet {
            UserDefaults.standard.setValue(setupFinshed, forKey: "setupFinished")
        }
    }
    
    public init() {
        fetch()
        fetchPodcastClients()
    }
    
    public func fetchPodcastClients() {
        Network.shared.apollo.fetch(query: PodcastClientsQuery(),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case let .success(graphQLResult):
                self.podcastClients = graphQLResult.data?.podcastClient?.compactMap { $0?.fragments.client } ?? []
            case let .failure(error):
                print("initializeFromCache Failure! Error: \(error)")
                self.podcastClients = []
            }
        }
    }
    
    func fetch(fetchNew: Bool = false) {
        Network.shared.apollo.fetch(
            query: ViewerModelQuery(),
            cachePolicy: fetchNew ? .fetchIgnoringCacheData : .returnCacheDataDontFetch
        ) { result in
            switch result {
            case let .success(graphQLResult):
                self.viewer = graphQLResult.data?.viewer?.fragments.viewerFragment
                if !fetchNew, self.viewer?.token != nil {
                    // fetch update
                    self.fetch(fetchNew: true)
                }
            case let .failure(error):
                self.logout()
                print("viewerModel fetch Failure! Error: \(error)")
            }
            self.initialized = true
        }
    }
    
    public func twitterSignIn(
        twitterId: String,
        twitterToken: String,
        twitterTokenSecret: String
    ) {
        Network.shared.apollo.perform(mutation: CreateViewerMutation(twitterId: twitterId,
                                                                     twitterToken: twitterToken,
                                                                     twitterTokenSecret: twitterTokenSecret)) { result in
            switch result {
            case let .success(graphQLResult):
                guard let viewerFragment = graphQLResult.data?.createViewer?.fragments.viewerFragment else { return }
                self.viewer = viewerFragment
                // manually update ViewerModelQuery cache
                Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    let data = try ViewerModelQuery.Data(
                        viewer: ViewerModelQuery.Data.Viewer(
                            ViewerFragment(unsafeResultMap: viewerFragment.resultMap)
                        )
                    )
                    try transaction.write(data: data, forQuery: ViewerModelQuery())
                }
                
            case let .failure(error):
                self.viewer = nil
                print("twitterSignIn Failure! Error: \(error)")
            }
        }
    }
    
    public func logout() {
        viewer = nil
        Network.shared.apollo.clearCache()
        viewerClient = nil
        setupFinshed = false
    }
}