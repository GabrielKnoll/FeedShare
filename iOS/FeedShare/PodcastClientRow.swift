//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct PodcastClientRow: View {
    let icon: String?
    let name: String
    let action: () -> Void
    
    public var body: some View {
        Button(action: self.action) {
            HStack {
                if let i = icon {
                    Artwork(url: i, size: 44.0)
                }
                Text(name)
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
