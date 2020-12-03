//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct PodcastClientRow: View {
    let client: Client

    init(client: Client) {
        self.client = client
    }

    public var body: some View {
        Button(action: {}) {
            HStack {
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
}
