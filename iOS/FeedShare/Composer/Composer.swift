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
            Navigation {
                ComposerSearch(composerModel: composerModel)
            }.padding(25)
            
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

            
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
