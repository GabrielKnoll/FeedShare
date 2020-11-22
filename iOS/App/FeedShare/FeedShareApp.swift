//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

@main
struct FeedShareApp: App {
    @ObservedObject var viewerModel = ViewerModel.shared

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = R.color.background()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            VStack {
                if self.viewerModel.initialized {
                    if false {
                        FeedStream()
                    } else {
                        Onboarding().environmentObject(viewerModel)
                    }
                } else {
                    Text("Loading")
                }
            }
        }
    }
}
