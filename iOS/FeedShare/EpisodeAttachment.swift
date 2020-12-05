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
        AttachmentFrame {
            Artwork(url: data.podcast.artwork, size: 65.0)
            VStack(alignment: .leading, spacing: 3) {
                Text(data.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(data.podcast.title)
                    .font(.subheadline)
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
        }
    }
}

struct Attachment_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // swiftlint:disable force_unwrapping
            //            AttachmentItem(data: results.first!.episode)
            //            AttachmentItem(data: results[1].episode)
            // swiftlint:enable force_unwrap
        }
    }
}
