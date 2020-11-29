//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct PodcastClientRow: View {
    let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    public var body: some View {
        Button(action: {
            
        }) {
            HStack {
                HStack {
                    URLImage(URL(string: client.icon)!, placeholder: Image(systemName: "circle")) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    }.frame(width: 44.0, height: 44.0).cornerRadius(10)
                    Text(client.displayName)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(10)
                .foregroundColor(.primary)
                .background(Color.primary.opacity(0.1))
                .cornerRadius(15)
            }
        }
    }
}
