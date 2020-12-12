//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI

public struct EpisodeOverlay: View {
    let attachment: EpisodeAttachmentFragment
    
    public var body: some View {
        VStack {
            Artwork(url: nil, size: 100)
            Text(attachment.title).font(.title)
            Text(attachment.podcast.title)
            Text(attachment.podcast.publisher)
        }.frame(minWidth: 0, maxWidth: .infinity)
        .padding(20)
    }
}
