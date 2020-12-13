//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI

@main
struct FeedShareApp: App {
    @ObservedObject var viewerModel = ViewerModel.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if viewerModel.initialized {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        OverlayHost {
                            FeedStream()
                        }
                    } else {
                        Onboarding()
                    }
                } else {
                    Loading()
                }
            }
            .environmentObject(viewerModel)
        }
    }
}
