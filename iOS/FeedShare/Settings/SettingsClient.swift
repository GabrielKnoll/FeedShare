//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct SettingsClient: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Your Podcast client").bold()
            PodcastClientRow(
                icon: viewerModel.viewerClient?.icon,
                name: viewerModel.viewerClient?.displayName ?? "Other"
            ) {
                navigationStack.push(SettingsClientList())
            }
        }
    }
}
