//
//  OnboardingPodcastClientModel.swift
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Foundation

public class OnboardingPodcastClientModel: ObservableObject {
    @Published public var podcastClients = [PodcastClientsQuery.Data.PodcastClient]()

    public init() {
        Network.shared.apollo.fetch(query: PodcastClientsQuery()) { result in
            switch result {
            case let .success(graphQLResult):
                self.podcastClients = graphQLResult.data?.podcastClient?.compactMap { $0 } ?? []
            case let .failure(error):
                print("initializeFromCache Failure! Error: \(error)")
                self.podcastClients = []
            }
        }
    }
}
