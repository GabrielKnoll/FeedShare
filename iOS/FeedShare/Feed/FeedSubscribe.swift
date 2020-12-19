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
            Text("Subscribe to your Personal Feed").fontWeight(.bold)
            Text("Your personal feed contains the podcast episodes shared by the people you follow. Subscribe to it in \(viewerModel.viewerClient?.displayName ?? "your Podcast client") to listen to them.")
            FeedLink()
            SubscribeButton(feed: viewerModel.viewer?.personalFeed)
        }
    }
}
