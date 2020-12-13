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
                }.padding(20)
            }
            
            Text("Which Episode do you want to share?").fontWeight(.bold)
            if let episodes = composerModel.latestEpisodes {
                if episodes.count == 0 {
                    Text("This Podcast does not have any episodes   ")
                } else {
                    ScrollView {
                        ForEach(episodes, id: \.id) { episode in
                            Button(action: {
                                composerModel.episode = episode
                                self.navigationStack.push(ComposerMessage(composerModel: composerModel))
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(episode.title).fontWeight(.bold).lineLimit(1)
                                        if let date = episode.datePublished.parseDateFormatRelative() {
                                            Text(date)
                                        }
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
                    }.padding(20)
                }
                
            } else {
                ActivityIndicator(style: .large)
            }
        }
    }
}
