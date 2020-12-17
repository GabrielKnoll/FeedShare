//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

@main
struct FeedShareApp: App {
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
        }
    }
}
