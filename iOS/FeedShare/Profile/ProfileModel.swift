//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public class ProfileModel: ObservableObject {
    @Published var user: ProfileQuery.Data.Node.AsUser?
    
    public init(id: String) {
        Network.shared.apollo.fetch(query: ProfileQuery(id: id), cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case let .success(graphQLResult):
                if let user = graphQLResult.data?.node?.asUser {
                    self.user = user
                }
            case .failure:
                print("Error loading ProfileQuery")
            }
        }
    }
}
