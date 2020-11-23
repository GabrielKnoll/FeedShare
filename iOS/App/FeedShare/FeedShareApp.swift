//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NavigationStack
import SwiftUI

@main
struct FeedShareApp: App {
    @ObservedObject var viewerModel = ViewerModel.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Loading()
                if self.viewerModel.setupFinshed {
                    FeedStream()
                    Tabbar()
                } else {
                    Onboarding()
                }
            }
            .environmentObject(viewerModel)
        }
    }
}
