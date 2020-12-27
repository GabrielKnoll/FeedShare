//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import OneSignal
import Shared
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("5f5335b9-b7e0-4cfa-9123-81fb6329113c")
        
        return true
    }
}

@main
struct FeedShareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var viewerModel = ViewerModel.shared
    @ObservedObject var overlayModel = OverlayModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if viewerModel.initialized {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        Feed()
                            .slideOverCard(isPresented: $overlayModel.visible) {
                                overlayModel.presentedView
                            }
                    } else {
                        Onboarding()
                    }
                } else {
                    Loading()
                }
            }
            .environmentObject(overlayModel)
            .environmentObject(viewerModel)
            .onReceive(viewerModel.$viewer, perform: { viewer in
                if let id = viewer?.user.id.components(separatedBy: ":").last {
                    OneSignal.setExternalUserId(id)
                }
            })
        }
    }
}
