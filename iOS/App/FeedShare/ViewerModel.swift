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
    static let shared = ViewerModel()
    
    @Published var viewerClient: ViewerClient? = {
        if let resultMap = UserDefaults.standard.dictionary(forKey: "ViewerClient") {
            return ViewerClient(unsafeResultMap: resultMap)
        }
        return nil
    }() {
        didSet {
            UserDefaults.standard.set(viewerClient?.jsonObject, forKey: "ViewerClient")
        }
    }
    @Published var viewer: ViewerFragment?
    @Published var initialized: Bool = false
    @Published var setupFinshed: Bool = UserDefaults.standard.bool(forKey: "setupFinished") {
        didSet {
            UserDefaults.standard.setValue(self.setupFinshed, forKey: "setupFinished")
        }
    }
    
    public init() {
        fetch()
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
                self.viewer = nil
                print("viewerModel fetch Failure! Error: \(error)")
            }
            self.initialized = true
        }
    }
    
    func twitterSignIn(
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
                    try transaction.update(query: ViewerModelQuery()) { (cache: inout ViewerModelQuery.Data) in
                        if cache.viewer != nil {
                            cache.viewer?.fragments.viewerFragment = viewerFragment
                        } else {
                            cache.viewer = ViewerModelQuery.Data.Viewer(unsafeResultMap: viewerFragment.resultMap)
                        }
                    }
                }
                
            case let .failure(error):
                self.viewer = nil
                print("twitterSignIn Failure! Error: \(error)")
            }
        }
    }
    
    func logout() {
        viewer = nil
        Network.shared.apollo.clearCache()
        viewerClient = nil
        setupFinshed = false
    }
}