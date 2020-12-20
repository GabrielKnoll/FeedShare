//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import OneSignal
import Shared
import SwiftUI
import URLImage

public struct Settings: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var notifications = OneSignal.getDeviceState()?.isSubscribed ?? false
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
                
                FeedLink()
                
                Spacer().frame(maxHeight: 10)
                
                SettingsClient()
                
                Spacer().frame(maxHeight: 10)
                
                Text("Notifications").bold()
                Toggle("Get notified when your friends recommend an episode", isOn: $notifications)
                    .onChange(of: notifications) { value in
                        print(value)
                        if value {
                            OneSignal.promptForPushNotifications(userResponse: { accepted in
                                if !accepted {
                                    self.notifications = false
                                    let alertController = UIAlertController(
                                        title: "Notifications are Disabled",
                                        message: "FeedShare will not be able to send notifications, because it's diabled in Settings. Please enable notifications from the Settings app.",
                                        preferredStyle: .alert
                                    )
                                    alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                                        if let bundleIdentifier = Bundle.main.bundleIdentifier,
                                           let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                                            if UIApplication.shared.canOpenURL(appSettings) {
                                                UIApplication.shared.open(appSettings)
                                            }
                                        }
                                    }))
                                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                    
                                    UIApplication.shared.windows.first?.rootViewController?.present(
                                        alertController,
                                        animated: true,
                                        completion: nil
                                    )
                                }
                            })
                        }
                        OneSignal.disablePush(!value)
                    }
                
                Spacer().frame(maxHeight: 10)
                
                Button(action: {
                    self.logoutAlert = true
                }) {
                    Text("Sign Out").fontWeight(.semibold).foregroundColor(.red)
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
