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
            Artwork(url: podcast.artwork, size: 70)
            VStack(alignment: .leading) {
                Text(podcast.title).fontWeight(.bold)
                Text(podcast.publisher)
            }.frame(width: .infinity)
        }
    }
}
