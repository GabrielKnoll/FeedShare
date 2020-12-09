//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI
import URLImage

public struct PodcastClientRow: View {
    let client: Client
    let action: () -> Void
    
    public var body: some View {
        Button(action: self.action) {
            HStack {
                Artwork(url: client.icon, size: 44.0)
                Text(client.displayName)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(10)
            .foregroundColor(.primary)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(15)
        }
    }
}
