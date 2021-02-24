//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct PodcastClients: View {
    @EnvironmentObject var viewerModel: ViewerModel
    var onSelect: () -> Void
    
    public var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(viewerModel.podcastClients, id: \.id) { client in
                    Button(action: {
                        viewerModel.viewerClient = client
                        onSelect()
                    }) {
                        Artwork(url: client.icon, size: 44.0)
                            .padding(.vertical, 10)
                        Text(client.displayName)
                    }.buttonStyle(RowButton())
                }
            }
            Spacer()
            Button(action: {
                viewerModel.viewerClient = nil
                onSelect()
            }) {
                Text("I’m using a different app")
            }
            .buttonStyle(LinkButton())
        }.onAppear(perform: viewerModel.fetchPodcastClients)
    }
}
