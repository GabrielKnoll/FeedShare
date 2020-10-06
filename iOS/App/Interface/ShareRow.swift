//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NetworkManager
import SwiftUI
import URLImage

struct ShareRow: View {
	let data: Share
    @State private var showPopover: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 10) {
				if let url = data.author.profilePicture {
                    URLImage(url, placeholder: Image(systemName: "circle")) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    }
                    .frame(width: 36.0, height: 36.0)
                    .cornerRadius(18)
                }
                VStack(alignment: .leading) {
                    Text(data.author.displayName)
                        .font(.headline)
                        .lineLimit(1)
                    Text("@\(data.author.handle)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
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
            if let attachment = data.attachment {
                AttachmentItem(data: (attachment))
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
		var results = [Share]()
		let _ = NetworkManager.success.feedData()
			.sink(receiveCompletion: { _ in },
				  receiveValue: { result in
					results = result
				  })
		VStack {
			ShareRow(data: results.first!)
			ShareRow(data: results[1])
		}
	}
}
