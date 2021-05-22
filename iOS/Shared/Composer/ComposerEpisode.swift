//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SkeletonUI
import SwiftUI
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
            if let data = composerModel.podcast {
                PodcastHeader(title: data.title, title2: data.publisher, artwork: data.artwork)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

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
                        }.buttonStyle(RowButton())
                    }
                    .padding(.horizontal, 20)
                } else {
                    ForEach(0 ..< 5) { _ in
                        ComposerEpisodeItem(episode: nil)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onReceive(composerModel.$episode, perform: { episode in
                if episode != nil {
                    self.selectedEpisode = true
                }
            })
        }
        .foregroundColor(Color(R.color.primaryColor.name))
        .navigationTitle("Episode")
        .onDisappear(perform: {
            if composerModel.episode == nil {
                composerModel.latestEpisodes = nil
                composerModel.podcast = nil
            }
        })
    }
}

// }

public struct ComposerEpisodeItem: View {
    let episode: EpisodeAttachmentFragment?

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(episode?.title)
                    .font(Typography.bodyBold)

                    .lineLimit(1)
                    .skeleton(with: episode == nil)
                    .shape(type: .capsule)
                    .frame(maxWidth: episode == nil ? 120.0 : .infinity, maxHeight: 14.0, alignment: .leading)
                EpisodeDate(datePublished: episode?.datePublished ?? "", durationSeconds: episode?.durationSeconds)
                    .font(Typography.meta)
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .skeleton(with: episode == nil)
                    .shape(type: .capsule)
                    .frame(maxHeight: 12.0)
                Text(episode?.description)
                    .font(Typography.body)
                    .lineLimit(3)
                    .skeleton(with: episode?.description == nil)
                    .multiline(lines: 3, scales: [0: 0.7, 1: 0.9, 2: 0.8])
                    .shape(type: .capsule)
            }
            .foregroundColor(Color(R.color.primaryColor.name))
            Spacer()
        }
        .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .foregroundColor(.primary)
    }
}
