//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct FeedItem: View {
    let data: ShareFragment
    
    @EnvironmentObject var overlayModel: OverlayModel
    @State private var episodePresented = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 10) {
                ProfilePicture(url: data.author.profilePicture, size: 36.0)
                VStack(alignment: .leading) {
                    if let displayName = data.author.displayName {
                        Text(displayName)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    RelativeTime(data.createdAt)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Button(action: { }) {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.primary)
                .font(.headline)
            }
            if let message = data.message {
                Text(message)
            }
            Button(action: {
                overlayModel.present(view: EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment))
            }) {
                EpisodeAttachment(data: data.episode.fragments.episodeAttachmentFragment)
            }
        }
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 22.0)
            .fill(Color(.white))
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)),
                    radius: 5.0,
                    x: 0.0,
                    y: 2.0))
    }
}

struct ShareRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                // swiftlint:disable force_unwrapping
                //				ShareRow(data: results.first!, isEditable: false)
                //				ShareRow(data: results[1], isEditable: false)
                // swiftlint:enable force_unwrapping
            }
            VStack {
                // swiftlint:disable force_unwrapping
                //				ShareRow(data: results.first!, isEditable: true)
                //				ShareRow(data: results[1], isEditable: true)
                // swiftlint:enable force_unwrapping
            }
        }
    }
}
