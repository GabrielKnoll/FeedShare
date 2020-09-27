//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

struct AttachmentItem: View {
    let data: AttachmentFragment
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .dropLeading, .pad ]
        return formatter
      }()
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let url = URL(string: data.artwork ?? "") {
                URLImage(url, placeholder: Image(systemName: "circle")) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }.frame(width: 65.0, height: 65.0)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(data.title)
                    .font(.headline)
                if let episode = data.asEpisode {
                    Text(episode.podcast.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let podcast = data.asPodcast {
                    Text(podcast.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let duration = data.asEpisode?.durationSeconds {
                    HStack {
                        Image(systemName: "clock")
                        Text(AttachmentItem.durationFormatter.string(from: TimeInterval(duration)) ?? "")
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            Spacer()
        }.background(Color.secondary.opacity(0.1))
        .cornerRadius(5)
    }
}

struct Attachment_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_try
        AttachmentItem(data: try! AttachmentFragment(jsonObject: [
            "title": "Luftpost Podcast",
            "artwork": "https://luftpost-podcast.de/cover.png",
            "__typename": "Podcast"
        ]))
    }
}
