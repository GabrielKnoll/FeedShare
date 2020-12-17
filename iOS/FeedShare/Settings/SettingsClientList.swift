//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct SettingsClientList: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Your Podcast client").fontWeight(.bold)
            PodcastClients(onSelect: {
                navigationStack.pop()
            })
        }.padding(20)
    }
}
