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
    @State private var notifications = OneSignal.getDeviceState()?.isSubscribed ?? false
    @State private var logoutAlert = false
    @ObservedObject var settingsModel = SettingsModel()
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Your Podcast client").bold()
                FeedLink()
                
                Spacer().frame(maxHeight: 10)
                
                SettingsClient()
                
                Spacer().frame(maxHeight: 10)
                
                Text("Notifications").bold()
                
                Toggle(isOn: $notifications) {
                    Text("Get notified when your friends recommend an episode")
                        .fixedSize(horizontal: false, vertical: true)
                }
                .onChange(of: notifications) { value in
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
                
                ForEach(settingsModel.pages, id: \.id) { page in
                    NavigationLink(
                        page.title,
                        destination: WebView(text: page.contentHtml ?? "")
                            .navigationBarTitle(page.title, displayMode: .large)
                    )
                }
                
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
                            self.viewerModel.logout()
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                            self.logoutAlert = false
                        })
                    )
                }
            }
            .padding(15)
        }
        .navigationBarTitle("Settings", displayMode: .large)
    }
}
