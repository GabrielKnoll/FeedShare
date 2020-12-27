//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct Feed: View {
    @EnvironmentObject var overlayModel: OverlayModel
    @EnvironmentObject var viewerModel: ViewerModel
    @StateObject var feedModel = FeedModel()
    @State private var feedType = 0
    @State private var composerVisible = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                VStack {
                    if !feedModel.initialized {
                        Spacer()
                        ActivityIndicator(style: .medium)
                        Spacer()
                    } else if feedModel.initialized, feedModel.shares.isEmpty {
                        FeedEmpty()
                    } else {
                        RefreshableScrollView(
                            refreshing: $feedModel.loading,
                            paddingTop: geo.safeAreaInsets.top + 57
                        ) {
                            LazyVStack {
                                ForEach(feedModel.shares.reversed(), id: \.node?.id) { edge in
                                    if let fragment = edge.node?.fragments.shareFragment {
                                        FeedItem(data: fragment)
                                            .padding(.top, 5)
                                            .padding(.trailing, 15)
                                            .padding(.leading, 15)
                                    }
                                }
                            }
                            .padding(.bottom, 25)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Image(R.image.logo.name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .padding(.leading, 7)
                        Spacer()
                        
                        Button(action: {
                            composerVisible = true
                        }) {
                            Image(R.image.composer.name)
                        }.foregroundColor(Color.primary)
                        
                        Button(action: {
                            overlayModel.present(view: Settings())
                        }) {
                            ProfilePicture(url: viewerModel.viewer?.user.profilePicture, size: 28)
                                .padding(7)
                        }
                    }
                    .padding(.horizontal, 8)
                    Picker(selection: $feedType, label: Text("What is your favorite color?")) {
                        Text("Friends").tag(0)
                        Text("Personal").tag(1)
                        Text("Global").tag(2)
                    }
                    .padding(.horizontal, 15)
                    .pickerStyle(SegmentedPickerStyle())
                    Divider()
                        .padding(0)
                        .offset(x: 0, y: 10)
                }
                .padding(.top, geo.safeAreaInsets.top)
                .padding(.bottom, 10)
                .background(BlurView(style: .extraLight))
                .edgesIgnoringSafeArea(.top)
                
            }
            .background(Color(R.color.background() ?? .gray))
            .edgesIgnoringSafeArea(.bottom)
            .onReceive(viewerModel.feedNotSubscribed) { _ in
                overlayModel.present(view: FeedSubscribe())
            }
            .sheet(isPresented: $composerVisible) {
                Composer(dismiss: { composerVisible = false })
                    .environmentObject(viewerModel)
            }
        }
    }
}
