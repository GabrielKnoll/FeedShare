//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

@main
struct FeedShareApp: App {

	init() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = R.color.background()
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}

    var body: some Scene {
        WindowGroup {
           FeedStream()
        }
    }
}
