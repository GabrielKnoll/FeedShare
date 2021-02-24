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
        guard let data = URL(string: "https://feed.buechele.cc") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    public var body: some View {
        switch type {
        case .user:
            Text("You haven't shared anything").fontWeight(.bold)
            Text("Episodes you shared with your followers will appear here.")
                .multilineTextAlignment(.center)
            Facepile()
            Button(action: inviteFriends) {
                Text("Invite Friends")
            }
        case .personal:
            Text("It's quiet here...").fontWeight(.bold)
            Text("Be the first of your friends to share an episode or explore the Global feed.")
                .multilineTextAlignment(.center)
            Facepile()
            Button(action: inviteFriends) {
                Text("Invite Friends")
            }
        default:
            Text("Empty")
        }
    }
}
