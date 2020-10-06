//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NetworkManager
import SwiftUI
import URLImage

struct AttachmentItem: View {
    let data: Attachment
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .dropLeading, .pad ]
        return formatter
      }()
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let url = URL(string: data.artwork ?? "http://google.com") {
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
                if let episode = data.episode {
                    Text(episode.podcast)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let podcast = data.podcast {
                    Text(podcast.publisher)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let duration = data.episode?.durationSeconds {
                    HStack {
                        Image(systemName: "clock")
                        Text(AttachmentItem.durationFormatter.string(from: TimeInterval(duration)) ?? "")
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
		var results = [Share]()
		let _ = NetworkManager.success.feedData()
			.sink(receiveCompletion: { _ in },
				  receiveValue: { result in
					results = result
				  })
		return VStack {
			AttachmentItem(data: results.first!.attachment!)
			AttachmentItem(data: results[1].attachment!)
		}
    }
}