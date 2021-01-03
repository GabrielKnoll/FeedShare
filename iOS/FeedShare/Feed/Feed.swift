//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import Shared
import SwiftUI

public struct Feed: View {
    let type: FeedType
    let paddingTop: CGFloat
    
    @StateObject var feedModel: FeedModel
    
    init(type: FeedType, paddingTop: CGFloat = 0) {
        self.paddingTop = paddingTop
        self.type = type
        _feedModel = StateObject(wrappedValue: FeedModel(type: type))
    }
    
    func inviteFriends() {
        guard let data = URL(string: "https://feed.buechele.cc") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    public var body: some View {
        VStack {
            if !feedModel.initialized {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            } else if feedModel.initialized, feedModel.shares.isEmpty {
                Spacer()
                Text("It's quiet here...").fontWeight(.bold)
                Text("Be the first of your friends to share an episode or explore the Global feed.")
                    .multilineTextAlignment(.center)
                Friends()
                Button(action: inviteFriends) {
                    Text("Invite Friends")
                }
                Spacer()
            } else {
                RefreshableScrollView(
                    refreshing: $feedModel.loading,
                    paddingTop: paddingTop
                ) {
                    LazyVStack {
                        ForEach(feedModel.shares.reversed(), id: \.node?.id) { edge in
                            if let fragment = edge.node?.fragments.shareFragment {
                                FeedItem(data: fragment)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding(.bottom, 25)
                }
            }
        }
    }
}
