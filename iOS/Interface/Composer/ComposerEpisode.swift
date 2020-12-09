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
    @EnvironmentObject private var navigationStack: NavigationStack
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        let relativeFormatter = RelativeDateTimeFormatter()
        
        formatter.dateStyle = .long
        return formatter
    }()
    
    public var body: some View {
        VStack {
            if composerModel.podcast != nil {
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
            if let episodes = composerModel.latestEpisodes {
                ScrollView {
                    ForEach(episodes, id: \.id) { episode in
                        Button(action: {
                            composerModel.episode = episode
                            self.navigationStack.push(ComposerMessage(composerModel: composerModel))
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(episode.title).fontWeight(.bold).lineLimit(1)
                                    Text(episode.datePublished)
                                    if let desc = episode.description {
                                        Text(desc)
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                            .lineLimit(3)
                                    }
                                }
                                Spacer()
                            }
                        }.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.primary)
                    }
                }
            } else {
                ActivityIndicator(style: .large)
            }
            
        }
    }
}
