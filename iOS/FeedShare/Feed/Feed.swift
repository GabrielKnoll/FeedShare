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
    @StateObject var feedStreamModel = FeedStreamModel()
    @State private var feedType = 0
    @State private var settingsPresented = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("LOGO").font(.headline)
                    Spacer()
                    Button(action: {
                        overlayModel.present(view: Settings())
                    }) {
                        Image(systemName: "person.fill")
                    }
                    
                    Button(action: {
                        overlayModel.present(view: Composer(dismiss: {}))
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }.padding(15)
                Picker(selection: $feedType, label: Text("What is your favorite color?")) {
                    Text("Friends").tag(0)
                    Text("Personal").tag(1)
                    Text("Global").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            RefreshableScrollView(refreshing: $feedStreamModel.loading) {
                LazyVStack {
                    ForEach(feedStreamModel.shares.reversed(), id: \.node?.id) { edge in
                        if let fragment = edge.node?.fragments.shareFragment {
                            FeedItem(data: fragment)
                                .padding(.top, 5)
                                .padding(.trailing, 15)
                                .padding(.leading, 15)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 25)
            }
        } 
        .background(Color(R.color.background() ?? .gray))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}
