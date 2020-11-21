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
            if self.viewerModel.initialized {
                if viewerModel.viewer != nil {
                    FeedStream()
                } else {
                    Login().environmentObject(viewerModel)
                }
            } else {
                Text("Loading")
            }
        }
    }
}
