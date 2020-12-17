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
            ForEach(viewerModel.podcastClients, id: \.id) { client in
                PodcastClientRow(icon: client.icon, name: client.displayName) {
                    viewerModel.viewerClient = client
                    onSelect()
                }
            }
            PodcastClientRow(icon: nil, name: "Other") {
                viewerModel.viewerClient = nil
                onSelect()
            }
        }.onAppear(perform: viewerModel.fetchPodcastClients)
    }
}
