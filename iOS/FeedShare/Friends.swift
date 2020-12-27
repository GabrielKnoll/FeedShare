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
    
    private let size: Double = 36
    private let border: CGFloat = 3
    private let overlap: CGFloat = -9
    
    public init() {}
    
    public var body: some View {
        if let following = viewerModel.viewer?.user.following as? [ViewerFragment.User.Following], !following.isEmpty {
            VStack {
                HStack {
                    ForEach(following.prefix(4), id: \.id) {person in
                        ProfilePicture(url: person.profilePicture, size: size)
                            .padding(border)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(21)
                            .padding(.horizontal, overlap)
                    }
                    ProfilePicture(url: nil, size: size)
                        .padding(border)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(21)
                        .padding(.horizontal, overlap)
                }
                let friends = following.count == 1
                    ? following.first?.displayName ?? ""
                    : "\(following[0].displayName ?? ""), \(following[1].displayName ?? "")"
                Text("\(friends) and others are already using FeedShare.").multilineTextAlignment(.center)
            }
        }
    }
}
