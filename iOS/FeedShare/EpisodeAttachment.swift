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
            if let url = URL(string: data.podcast.artwork ?? "") {
                URLImage(url, placeholder: Image(systemName: "circle")) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }.frame(width: 65.0, height: 65.0).cornerRadius(10)
            }
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 15)
            .stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        .cornerRadius(15)
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
