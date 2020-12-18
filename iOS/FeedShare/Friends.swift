//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct Friends: View {
    @EnvironmentObject var viewerModel: ViewerModel
    
    public init() {}
    
    public var body: some View {
        if let following = viewerModel.viewer?.user.following as? [ViewerFragment.User.Following], !following.isEmpty {
            VStack {
                HStack {
                    ForEach(following.prefix(4), id: \.id) {person in
                        ProfilePicture(url: person.profilePicture, size: 36).padding(.horizontal, -7)
                    }
                    ProfilePicture(url: nil, size: 36).padding(.horizontal, -7)
                }
                let friends = following.count == 1
                    ? following.first?.displayName ?? ""
                    : "\(following[0].displayName ?? ""), \(following[1].displayName ?? "")"
                Text("\(friends) and others are already using FeedShare.").multilineTextAlignment(.center)
            }
        }
    }
}
