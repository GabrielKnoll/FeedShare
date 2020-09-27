//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

struct ShareRow: View {
    let data: ShareFragment
    @State private var showPopover: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 10) {
                if let url = URL(string: data.author.profilePicture ?? "") {
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
            Spacer(minLength: 15)
            if let message = data.message {
                Text(message)
                Spacer(minLength: 15)
            }
            if let attachment = data.attachment {
                AttachmentItem(data: (attachment.fragments.attachmentFragment))
            }
        }
        .padding(10)
    }
}

struct ShareRow_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
