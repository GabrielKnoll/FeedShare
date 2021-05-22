//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import OneSignal
import PartialSheet
import Shared
import SwiftUI
import URLImage

public struct Profile: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State private var settingsActive = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewerModel.viewer?.user.displayName ?? "")
                        .font(Typography.title2)
                    Text("\(viewerModel.viewer?.user.followers.totalCount ?? 0) ").font(Typography.bodyBold) +
                        Text("Followers ").font(Typography.body) +
                        Text("\(viewerModel.viewer?.user.following.totalCount ?? 0) ").font(Typography.bodyBold) +
                        Text("Following").font(Typography.body)
                }
                .foregroundColor(Color(R.color.primaryColor.name))
                Spacer()
                ProfilePicture(url: viewerModel.viewer?.user.profilePicture, size: 80.0)
            }
            .padding(20)
            .frame(minWidth: 0, maxWidth: .infinity)

            Feed(type: .user, paddingTop: 10)
            NavigationLink(destination: Settings(), isActive: self.$settingsActive) {
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .navigationBarItems(trailing: Button(action: { settingsActive = true }) {
            Image(systemName: "gearshape")
        }
        .contentShape(Rectangle())
        .padding(10))
        .background(Color(R.color.backgroundColor.name))
    }
}
