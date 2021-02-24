//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct PodcastHeader: View {
    let title: String
    let title2: String
    let artwork: String?
    
    public init(title: String, title2: String, artwork: String?) {
        self.title = title
        self.title2 = title2
        self.artwork = artwork
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Artwork(url: self.artwork, size: 100)
            VStack(alignment: .leading) {
                Text(self.title2)
                    .font(Typography.caption)
                    .foregroundColor(Color(R.color.brandColor.name))
                    .lineLimit(1)
                Text(self.title)
                    .font(Typography.title2)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}
