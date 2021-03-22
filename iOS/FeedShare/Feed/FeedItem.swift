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
            NavigationLink(destination: EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment)) {
                EpisodeAttachment(data: data.episode.fragments.episodeAttachmentFragment)
            }

            if let message = data.message {
                Text(message).font(Typography.body)
            }
            HStack(alignment: .center, spacing: 5) {
                ProfilePicture(url: data.author.profilePicture, size: 28.0)
                    .padding(.trailing, 4)
                if let displayName = data.author.displayName {
                    Text(displayName)
                        .font(Typography.meta)
                        .lineLimit(1)
                }
                Text("·")
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .font(Typography.meta)
                RelativeTime(data.createdAt)
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .font(Typography.meta)
                    .lineLimit(1)
                if data.isInGlobalFeed != true {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(R.color.secondaryColor.name))
                        .font(.system(size: 13))
                }
                Spacer()
            }.font(Typography.bodyMedium)
        }
        .foregroundColor(Color(R.color.primaryColor.name))
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color(R.color.primaryColor.name).opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
