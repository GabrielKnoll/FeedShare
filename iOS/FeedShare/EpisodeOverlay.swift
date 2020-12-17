//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct EpisodeOverlay: View {
    let attachment: EpisodeAttachmentFragment
    @ObservedObject var data: EpisodeOverlayModel
    @EnvironmentObject var viewerModel: ViewerModel
    
    init(attachment: EpisodeAttachmentFragment) {
        self.attachment = attachment
        self.data = EpisodeOverlayModel(id: attachment.id)
    }
    
    public var body: some View {
        VStack {
            Artwork(url: self.data.artwork ?? self.attachment.artwork, size: 100)
            Text(attachment.title).font(.title)
            Text(attachment.podcast.title)
            Text(attachment.podcast.publisher)
            if let desc = data.description {
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
            
            SubscribeButton(feed: data.feed)
        }.frame(minWidth: 0, maxWidth: .infinity)
        .padding(20)
    }
}
