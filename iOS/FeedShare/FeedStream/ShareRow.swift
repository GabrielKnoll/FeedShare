//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI
import URLImage

public struct ShareRow: View {
    let data: ShareFragment
    
    @EnvironmentObject var overlayModel: OverlayModel
    @State private var showPopover: Bool = false
    @State private var editorText: String = "What did you like about this episode?"

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
                    if let date = data.createdAt.parseDateTimeFormatRelative() {
                        Text(date)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Button(action: { showPopover = true }) {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.primary)
                .font(.headline)
                .popover(
                    isPresented: self.$showPopover,
                    arrowEdge: .bottom
                ) { Text("Popover") }
            }
            if let message = data.message {
                Text(message)
            }
            Button(action: {
                overlayModel.present(EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment))
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
