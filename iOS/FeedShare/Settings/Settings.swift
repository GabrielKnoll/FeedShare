//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI
import URLImage

public struct Settings: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var notifications = false
    @State private var logoutAlert = false
    
    public var body: some View {
        NavigationStackView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .center) {
                    ProfilePicture(url: viewerModel.viewer?.user.profilePicture, size: 66.0)
                    Text(viewerModel.viewer?.user.displayName ?? "").font(.headline)
                    Text("@\(viewerModel.viewer?.user.handle ?? "")").font(.subheadline)
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Spacer().frame(maxHeight: 10)
                
                FeedLink(text: viewerModel.viewer?.personalFeed ?? "")
                
                Spacer().frame(maxHeight: 10)
                
                SettingsClient()
                
                Spacer().frame(maxHeight: 10)
                
                Text("Notifications").bold()
                Toggle("Get notified when your friends recommend an episode", isOn: $notifications)
                
                Spacer().frame(maxHeight: 10)
                
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
                            //self.visible.toggle()
                            self.viewerModel.logout()
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                            self.logoutAlert = false
                        })
                    )
                }
            }.padding(15)
        }
    }
}
