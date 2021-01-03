//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import Shared
import SwiftUI
import URLImage

public struct FeedItem: View {
    let data: ShareFragment
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State private var episodePresented = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    // dismissed
                }) {
                    EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment)
                }
            }) {
                EpisodeAttachment(data: data.episode.fragments.episodeAttachmentFragment)
            }
            
            if let message = data.message {
                Text(message)
            }
            HStack(alignment: .center) {
                ProfilePicture(url: data.author.profilePicture, size: 28.0)
                    .padding(.trailing, 4)
                if let displayName = data.author.displayName {
                    Text(displayName)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                RelativeTime(data.createdAt)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Spacer()
            }
            
        }
        .padding(15)
        .background(Color(.systemBackground))
    }
}
