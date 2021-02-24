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
        switch self.type {
        case .global:
            _feedModel = StateObject(wrappedValue: FeedModel.global)
        case .personal:
            _feedModel = StateObject(wrappedValue: FeedModel.personal)
        case .user:
            _feedModel = StateObject(wrappedValue: FeedModel.user)
        case .__unknown(_):
            _feedModel = StateObject(wrappedValue: FeedModel.global)
        }
        
    }
    
    public var body: some View {
        VStack {
            if !feedModel.initialized {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            } else if feedModel.initialized, feedModel.shares.isEmpty {
                Spacer()
                FeedEmpty(type: type)
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
                                    .padding(.horizontal, 15)
                            }
                        }
                    }
                    .padding(.bottom, 25)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(R.color.primaryColor.name).opacity(0.10),
                        Color(R.color.primaryColor.name).opacity(0.0),
                        .clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom)
                    .allowsHitTesting(false)
                    .frame(height: 32)
                    .padding(.top, paddingTop - 10),
                 alignment: .top)
        .background(Color(R.color.lightWashColor.name))
        .edgesIgnoringSafeArea(.bottom)
    }
}
