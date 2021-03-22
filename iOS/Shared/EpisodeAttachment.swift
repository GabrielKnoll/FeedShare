//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct EpisodeAttachment: View {
    let data: EpisodeAttachmentFragment

    public init(data: EpisodeAttachmentFragment) {
        self.data = data
    }

    public static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = [.dropLeading]
        return formatter
    }()

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Artwork(url: data.artwork ?? data.podcast.artwork, size: 75.0)

            VStack(alignment: .leading) {
                Text(data.title)
                    .font(Typography.headline)
                    .lineLimit(1)
                Text(data.podcast.title)
                    .font(Typography.bodyMedium)
                    .lineLimit(1)
                EpisodeDate(datePublished: data.datePublished, durationSeconds: data.durationSeconds)
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .font(Typography.meta)
                    .lineLimit(1)
            }
            .foregroundColor(Color(R.color.primaryColor.name))
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 80.0, alignment: .center)
    }
}
