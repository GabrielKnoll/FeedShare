//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerEpisode: View {
    @ObservedObject var composerModel: ComposerModel
    
    public var body: some View {
        VStack {
            if (composerModel.podcast != nil) {
                HStack {
                    Artwork(url: composerModel.podcast?.artwork, size: 70)
                    VStack(alignment: .leading) {
                        Text(composerModel.podcast?.title ?? "").fontWeight(.bold)
                        Text(composerModel.podcast?.publisher ?? "")
                    }
                    Spacer()
                }
            }
            
            Text("Which Episode do you want to share?").fontWeight(.bold)
            List(composerModel.latestEpisodes, id: \.id) { episode in
                VStack(alignment: .leading) {
                    Text(episode.title).fontWeight(.bold).lineLimit(1)
                    Text("18. November 2021")
                }.frame(width: .infinity)
            }
        }
    }
}
