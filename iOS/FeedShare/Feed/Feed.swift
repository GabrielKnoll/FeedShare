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
    @State private var settingsPresented = false
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if !feedModel.initialized {
                    Spacer()
                    ActivityIndicator(style: .large)
                    Spacer()
                } else if feedModel.initialized, feedModel.shares.isEmpty {
                    FeedEmpty()
                } else {
                    RefreshableScrollView(refreshing: $feedModel.loading) {
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
            
            GeometryReader { geo in
                VStack {
                    HStack {
                        Image(R.image.logo.name)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 70)
                        Spacer()
                        Button(action: {
                            overlayModel.present(view: Settings())
                        }) {
                            Image(systemName: "person.fill")
                        }.foregroundColor(Color.primary)
                        
                        Button(action: {
                            overlayModel.present(view: Composer(dismiss: {}))
                        }) {
                            Image(systemName: "square.and.pencil")
                        }.foregroundColor(Color.primary)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
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
        } 
        .background(Color(R.color.background() ?? .gray))
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(viewerModel.feedNotSubscribed) { _ in
            overlayModel.present(view: FeedSubscribe())
        }
        
    }
}
