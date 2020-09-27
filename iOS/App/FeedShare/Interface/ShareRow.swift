//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct ShareRow: View {
    let data: ShareFragment
    @State private var showPopover: Bool = false
    
//    private let buttonAction =
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 10) {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(15)
                Text(data.author.handle)
                    .font(.headline)
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
            Spacer(minLength: 15)
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
