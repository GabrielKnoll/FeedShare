//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct FeedEmpty: View {
    
    func inviteFriends() {
        guard let data = URL(string: "https://feed.buechele.cc") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("It's quiet here...").fontWeight(.bold)
            Text("Be the first of your friends to share an episode or explore the Global feed.")
                .multilineTextAlignment(.center)
            Friends()
            Button(action: inviteFriends) {
                Text("Invite Friends")
            }
            Spacer()
        }
    }
}
