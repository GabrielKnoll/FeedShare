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
    
    private var sectionPadding: CGFloat = 18
    private var titlePadding: CGFloat = 7
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Podcast App")
                    .font(Typography.button)
                    .padding(.top, sectionPadding)
                    .padding(.bottom, titlePadding)
                
                SettingsClient()
                
                Text("Personal Feed")
                    .font(Typography.button)
                    .padding(.top, sectionPadding)
                    .padding(.bottom, titlePadding)
                
                Text("Subscribe to your Personal Feed to listen to episodes recommended by people you follow right in your podcast app.")
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .font(Typography.body)
                    .padding(.bottom, titlePadding)
                
                FeedLink()
                
                if let client = viewerModel.viewerClient {
                    Button(action: {
                        SubscribeButton.openURL(client, feed: viewerModel.viewer?.personalFeed)
                    }) {
                        Text("Subscribe in \(client.displayName)").foregroundColor(Color(R.color.primaryColor.name))
                    }
                    .buttonStyle(LinkButton())
                    .padding(.vertical, -5)
                }
                
                Text("Notifications")
                    .font(Typography.button)
                    .padding(.top, sectionPadding)
                    .padding(.bottom, titlePadding)
                
                Toggle(isOn: $notifications) {
                    Text("Get notified when a person you follow recommends a new episode")
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color(R.color.secondaryColor.name))
                        .font(Typography.body)
                }
                .toggleStyle(SwitchToggleStyle(tint: Color(R.color.brandColor.name)))
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
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(settingsModel.pages, id: \.id) { page in
                        NavigationLink(
                            destination: WebView(text: page.contentHtml ?? "")
                                .navigationBarTitle(page.title, displayMode: .large)
                        ) {
                            Text(page.title)
                                .font(Typography.button)
                                .frame(minHeight: 44)
                        }
                    }
                }
                .padding(.top, sectionPadding)
                
                Button(action: {
                    self.logoutAlert = true
                }) {
                    Text("Sign Out")
                        .font(Typography.button)
                        .foregroundColor(Color(R.color.dangerColor.name))
                        .frame(minHeight: 44)
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
            .padding(.horizontal, 20)
            .foregroundColor(Color(R.color.primaryColor.name))
        }
        .navigationBarTitle("Settings", displayMode: .large)
        
    }
}
