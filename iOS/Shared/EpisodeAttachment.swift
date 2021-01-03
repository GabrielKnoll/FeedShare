//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct EpisodeAttachment: View {
    
    public init(data: EpisodeAttachmentFragment) {
        self.data = data
    }
    
    let data: EpisodeAttachmentFragment
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.dropLeading, .pad]
        return formatter
    }()
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Artwork(url: data.artwork ?? data.podcast.artwork, size: 65.0)
            VStack(alignment: .leading, spacing: 3) {
                Text(data.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                Text(data.podcast.title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                
                if let duration = data.durationSeconds {
                    HStack {
                        Image(systemName: "clock")
                        Text(EpisodeAttachment.durationFormatter.string(from: TimeInterval(duration)) ?? "")
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 65.0, alignment: .center)
    }
}
