//
//  OnboardingPodcastClientModel.swift
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Foundation

public class OnboardingPodcastClientModel: ObservableObject {
    @Published public var podcastClients = [Client]()
    
    public init() {
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
}
