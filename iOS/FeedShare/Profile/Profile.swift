//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct Profile: View {
    let userId: String
    @ObservedObject var profileModel: ProfileModel
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var settingsActive = false
    
    init(userId: String) {
        self.userId = userId
        self.profileModel = ProfileModel(id: userId)
    }

    public var body: some View {
        let isViewer = viewerModel.viewer?.user.id == userId
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(profileModel.user?.displayName ?? "")
                        .font(Typography.title2)
                    Text("\(profileModel.user?.followers.totalCount ?? 0) ").font(Typography.bodyBold) +
                        Text("Followers ").font(Typography.body) +
                        Text("\(profileModel.user?.following.totalCount ?? 0) ").font(Typography.bodyBold) +
                        Text("Following").font(Typography.body)
                }
                .foregroundColor(Color(R.color.primaryColor.name))
                Spacer()
                ProfilePicture(url: profileModel.user?.profilePicture, size: 80.0)
            }
            .padding(20)
            .frame(minWidth: 0, maxWidth: .infinity)

            Feed(type: .User(id: self.userId), paddingTop: 10)
            NavigationLink(destination: Settings(), isActive: self.$settingsActive) {
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isViewer ? "Profile" : "")
        .navigationBarItems(trailing: Button(action: { settingsActive = true }) {
            if isViewer {
                Image(systemName: "gearshape")
            }
        }
        .contentShape(Rectangle())
        .padding(10))
        .background(Color(R.color.backgroundColor.name))
    }
}
