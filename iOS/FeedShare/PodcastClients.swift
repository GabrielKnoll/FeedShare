//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct PodcastClients: View {
    @EnvironmentObject var viewerModel: ViewerModel
    var onSelect: () -> Void

    public var body: some View {
        VStack {
            ForEach(viewerModel.podcastClients, id: \.id) { client in
                PodcastClientRow(client: client) {
                    viewerModel.viewerClient = client
                    onSelect()
                }
            }
        }//.onAppear(perform: viewerModel.fetchPodcastClients)
    }
}
