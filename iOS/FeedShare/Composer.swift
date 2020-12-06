//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NavigationStack
import SwiftUI
import URLImage

public struct Composer: View {
    @Binding var visible: Bool
    @StateObject var composerModel = ComposerModel()
    
    public var body: some View {
        Overlay(visible: $visible) {
            
            NavigationStackView {
                ComposerSearch(composerModel: composerModel)
            }
            //                NavigationLink(
            //                    "Search",
            //                    destination: ComposerSearch(composerModel: composerModel),
            //                    tag: PushItem.search,
            //                    selection: $selectedPushItem
            //                )
            //                NavigationLink(
            //                    "Episode",
            //                    destination: ComposerEpisode(composerModel: composerModel),
            //                    tag: PushItem.episode,
            //                    selection: $selectedPushItem
            //                )
            //                NavigationLink(
            //                    "Message",
            //                    destination: ComposerEpisode(composerModel: composerModel),
            //                    tag: PushItem.message,
            //                    selection: $selectedPushItem
            //                )
            
            //                    NavigationLink(destination: ComposerEpisodeSelector(composerModel: composerModel), isActive: $isShowingDetailView) {
            //                        if !composerModel.latestEpisodes.isEmpty, !composerModel.isLoading, composerModel.episode == nil {
            //                            ComposerEpisodeSelector(composerModel: composerModel)
            //                        }
            //                    }
            //
            //                    AttachmentFrame {
            //                        if let episode = composerModel.episode {
            //                            EpisodeAttachment(data: episode)
            //                        } else if composerModel.isLoading {
            //                            ActivityIndicator(style: .medium)
            //                        } else if let podcast = composerModel.podcast {
            //                            Text(podcast.title)
            //                        } else {
            //                            Button(action: {
            //                                self.pastedString = UIPasteboard.general.string
            //                                if let url = self.pastedString, url.lowercased().hasPrefix("http") {
            //                                    composerModel.resolveUrl(url: url)
            //                                } else {
            //                                    self.unresolvedUrlAlert = true
            //                                }
            //                            }) {
            //                                Text("Paste from Clipboard")
            //                            }
            //                        }
            //                    }
            
        }
    }
}
