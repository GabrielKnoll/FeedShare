//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct SettingsClientList: View {
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Your Podcast client").fontWeight(.bold)
            PodcastClients(onSelect: {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .navigationBarTitle("Podcast Client", displayMode: .large)
        .padding(20)
    }
}
