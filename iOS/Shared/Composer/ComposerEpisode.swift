//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import SkeletonUI
import URLImage

public struct ComposerEpisode: View {
    @ObservedObject var composerModel: ComposerModel
    @State var selectedEpisode = false
    
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
            
            ScrollView {
                NavigationLink(
                    destination: ComposerMessage(composerModel: composerModel),
                    isActive: $selectedEpisode
                ) {
                    EmptyView()
                }
                
                if let episodes = composerModel.latestEpisodes {
                    ForEach(episodes, id: \.id) { episode in
                        Button(action: {
                            composerModel.episode = episode
                        }) {
                            ComposerEpisodeItem(episode: episode)
                        }
                    }
                } else {
                    ForEach(0..<5) { _ in
                        ComposerEpisodeItem(episode: nil)
                    }
                }
            }
            .onReceive(composerModel.$episode, perform: {episode in
                if episode != nil {
                    self.selectedEpisode = true
                }
            })
        }
        .navigationTitle(selectedEpisode ? "Episodes" : composerModel.podcast?.title ?? "")
        .onDisappear(perform: {
            if composerModel.episode == nil {
                composerModel.latestEpisodes = nil
                composerModel.podcast = nil
            }
        })
    }
}
//}

public struct ComposerEpisodeItem: View {
    let episode: EpisodeAttachmentFragment?
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(episode?.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .skeleton(with: episode == nil)
                    .shape(type: .capsule)
                    .frame(maxWidth: episode == nil ? 120.0 : .infinity, maxHeight: 14.0, alignment: .leading)
                let date = episode?.datePublished.parseDateFormatRelative()
                Text(date)
                    .skeleton(with: date == nil)
                    .shape(type: .capsule)
                    .frame(maxHeight: 12.0)
                Text(episode?.description)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .skeleton(with: episode?.description == nil)
                    .multiline(lines: 3, scales: [0: 0.7, 1: 0.9, 2: 0.8])
                    .shape(type: .capsule)
            }
            Spacer()
        }
        .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding(.horizontal, 20)
        .foregroundColor(.primary)
    }
}
