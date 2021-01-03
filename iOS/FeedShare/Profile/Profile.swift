//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import OneSignal
import Shared
import SwiftUI
import URLImage

public struct Profile: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State private var settingsActive = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .center) {
                ProfilePicture(url: viewerModel.viewer?.user.profilePicture, size: 66.0)
                Text(viewerModel.viewer?.user.displayName ?? "")
                    .font(.title2)
                    .bold()
                HStack {
                    Text("0 Followers")
                    Text("0 Following")
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
            Feed(type: .personal)
            NavigationLink(destination: Settings(), isActive: self.$settingsActive) {
                EmptyView()
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 20)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .navigationBarItems(trailing: Button(action: { settingsActive = true }) {
            Image(systemName: "gearshape")
        })
    }
}
