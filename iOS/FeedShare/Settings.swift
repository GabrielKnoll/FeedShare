//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct Settings: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var notifications = false
    @State private var logoutAlert = false
    @Binding var settingsVisible: Bool

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.settingsVisible = false
                }) {
                    Text("Close")
                }
            }
            if let url = URL(string: viewerModel.viewer?.user.profilePicture ?? "") {
                URLImage(url, placeholder: Image(systemName: "circle")) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }.frame(width: 66.0, height: 66.0).cornerRadius(33)
            }
            Text(viewerModel.viewer?.user.displayName ?? "").font(.headline)
            Text(viewerModel.viewer?.user.handle ?? "").font(.subheadline)

            VStack(alignment: .leading) {
                if let client = viewerModel.viewerClient {
                    Text("Your Podcast client").bold()
                    PodcastClientRow(client: client)
                }

                Text("Notifications").bold()
                Toggle("Get notified when your friends recommend an episode", isOn: $notifications)

                Button(action: {
                    self.logoutAlert = true
                }) {
                    Text("Sign Out").foregroundColor(.red)
                }
                .alert(isPresented: $logoutAlert) {
                    Alert(
                        title: Text("Log Out"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Log Out"), action: {
                            self.viewerModel.logout()
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                            self.logoutAlert = false
                        })
                    )
                }
            }
        }.padding(15)
    }
}
