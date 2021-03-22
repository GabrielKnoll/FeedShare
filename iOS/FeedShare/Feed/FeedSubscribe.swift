//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct FeedSubscribe: View {
    @EnvironmentObject var viewerModel: ViewerModel

    public var body: some View {
        VStack(alignment: .center) {
            Text("Subscribe to your Personal Feed")
                .font(Typography.headline)
                .padding(.vertical, 5)
            Text("Your personal feed contains the podcast episodes shared by the people you follow. Subscribe to it in \(viewerModel.viewerClient?.displayName ?? "your Podcast app").")
                .font(Typography.body)
                .foregroundColor(Color(R.color.secondaryColor.name))
                .multilineTextAlignment(.center)
            FeedLink()
            SubscribeButton(feed: viewerModel.viewer?.personalFeed)
        }
        .padding(.horizontal, 20)
        .foregroundColor(Color(R.color.primaryColor.name))
    }
}
