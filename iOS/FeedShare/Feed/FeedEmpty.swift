//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import Shared
import SwiftUI

public struct FeedEmpty: View {
    let type: FeedType

    func inviteFriends() {
        guard let data = URL(string: "https://findtruffle.com") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

    public var body: some View {
        switch type {
        case .user:
            EmptyState(
                title: "You haven't shared anything",
                message: "Episodes you shared with your followers will appear here."
            )
        case .personal:
            EmptyState(
                title: "It's quiet here...",
                message: "Be the first of your friends to share an episode or explore the Global feed."
            )
        case .global:
            Text("")
        case .__unknown:
            Text("")
        }
    }
}
