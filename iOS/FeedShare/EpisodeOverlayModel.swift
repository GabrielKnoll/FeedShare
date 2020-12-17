//
//  EpisodeOverlayModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import Network
import Shared

public class EpisodeOverlayModel: ObservableObject {
    @Published public var description: String?
    @Published public var artwork: String?
    @Published public var feed: String?
    
    public init(id: String) {
        Network.shared.apollo.fetch(query: EpisodeOverlayQuery(id: id),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case let .success(graphQLResult):
                self.description = graphQLResult.data?.node?.asEpisode?.description
                self.artwork = graphQLResult.data?.node?.asEpisode?.artwork ?? graphQLResult.data?.node?.asEpisode?.podcast.artwork
                self.feed = graphQLResult.data?.node?.asEpisode?.podcast.feed
            case let .failure(error):
                print("error \(error)")
            }
        }
    }
}
