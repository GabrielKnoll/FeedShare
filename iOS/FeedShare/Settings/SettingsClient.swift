//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI

public struct SettingsClient: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let client = viewerModel.viewerClient {
                Text("Your Podcast client").bold()
                PodcastClientRow(client: client) {
                    navigationStack.push(PodcastClients(onSelect: {
                        navigationStack.pop()
                    }))
                }
            }
        }
    }
}
