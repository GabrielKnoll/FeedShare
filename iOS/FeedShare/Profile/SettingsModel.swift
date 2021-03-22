//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public class SettingsModel: ObservableObject {
    @Published var pages = [SettingsQuery.Data.Page]()

    public init() {
        Network.shared.apollo.fetch(query: SettingsQuery(), cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case let .success(graphQLResult):
                if let pages = graphQLResult.data?.pages {
                    self.pages = pages.compactMap { $0 }
                }
            case .failure:
                print("Error loading SettinsQuery")
            }
        }
    }
}
