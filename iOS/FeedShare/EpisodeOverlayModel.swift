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
    @Published public var fragment: EpisodeOverlayFragment?

    public init(id: String) {
        Network.shared.apollo.fetch(query: EpisodeOverlayQuery(id: id),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case let .success(graphQLResult):
                self.fragment = graphQLResult.data?.node?.asEpisode?.fragments.episodeOverlayFragment
            case let .failure(error):
                print("error \(error)")
            }
        }
    }
}
