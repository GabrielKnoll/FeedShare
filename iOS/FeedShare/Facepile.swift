//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct Facepile: View {
    @EnvironmentObject var viewerModel: ViewerModel
    
    private let size: Double = 36
    private let border: CGFloat = 3
    private let overlap: CGFloat = -9
    
    public init() {}
    
    public var body: some View {
        let following: [FollowFragment] = viewerModel.viewer?.user.following.edges?.compactMap { $0?.node?.fragments.followFragment } ?? []
        let followers: [FollowFragment] = viewerModel.viewer?.user.followers.edges?.compactMap { $0?.node?.fragments.followFragment } ?? []
        let persons: [FollowFragment] = (following + followers).removingDuplicates()
        
        if !persons.isEmpty {
            VStack {
                HStack {
                    ForEach(persons.prefix(4), id: \.id) {person in
                        ProfilePicture(url: person.profilePicture, size: size)
                            .padding(border)
                            .background(Color(R.color.backgroundColor.name))
                            .cornerRadius(21)
                            .padding(.horizontal, overlap)
                    }
//                    ProfilePicture(url: nil, size: size)
//                        .padding(border)
//                        .background(Color(R.color.backgroundColor.name))
//                        .cornerRadius(21)
//                        .padding(.horizontal, overlap)
                }
                let friends = persons.count == 1
                    ? persons.first?.displayName ?? ""
                    : "\(persons[0].displayName ?? ""), \(persons[1].displayName ?? "")"
                Text("\(friends) and others are already using Truffle.")
                    .multilineTextAlignment(.center)
                    .font(Typography.caption)
                    .foregroundColor(Color(R.color.secondaryColor.name))
            }
        }
    }
}

extension FollowFragment: Equatable {
    public static func == (lhs: FollowFragment, rhs: FollowFragment) -> Bool {
        return lhs.id == rhs.id
    }
}

extension FollowFragment: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
