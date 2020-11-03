//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import Logic
import NetworkManager
import NetworkManagerLive
import SwiftUI

@main
struct FeedShareApp: App {
    @ObservedObject var viewerModel: ViewerModel
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = R.color.background()
        self.viewerModel = ViewerModel(networkManager: NetworkManager.live)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            if !self.viewerModel.isLoggedIn {
                Login(viewerModel: self.viewerModel)
            } else {
                FeedStream(viewModel: FeedStreamViewModel(networkManager: NetworkManager.live))
            }
        }
    }
}
