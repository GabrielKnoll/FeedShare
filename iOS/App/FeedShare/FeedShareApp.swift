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
    let twitter: TwitterService

	init() {
		let appearance = UINavigationBarAppearance()
        self.twitter = TwitterService()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = R.color.background()
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}

	var body: some Scene {
		WindowGroup {
            if self.twitter.credential?.userId == nil {
                Login().environmentObject(self.twitter)
            } else {
                FeedStream(viewModel: FeedStreamViewModel(networkManager: NetworkManager.live))
            }
        }
	}
}
