//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerPodcast: View {
    var podcast: ComposerPodcastFragment

    public var body: some View {
        HStack {
            Artwork(url: podcast.artwork, size: 65.0)
            VStack(alignment: .leading) {
                Text(podcast.title)
                    .font(Typography.bodyBold)
                    .lineLimit(2)
                Text(podcast.publisher)
                    .font(Typography.meta)
                    .lineLimit(1)
                    .foregroundColor(Color(R.color.secondaryColor.name))
            }
            .foregroundColor(Color(R.color.primaryColor.name))
            Spacer()
        }
    }
}
