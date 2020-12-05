//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct Composer: View {
    @Binding var visible: Bool
    @StateObject var composerModel = ComposerModel()
    @State private var activePage = 0
    
    
    public var body: some View {
        Overlay(visible: $visible) {
            NavigationView {
                ComposerSearch(composerModel: composerModel)
                
                let binding = Binding<Bool>(
                    get: { composerModel.podcast != nil },
                    set: { _,_ in  }
                )
                NavigationLink("title", destination: ComposerEpisodeSelector(composerModel: composerModel), isActive: binding)
                    
//                    NavigationLink(destination: ComposerEpisodeSelector(composerModel: composerModel), isActive: $isShowingDetailView) {
////                        if !composerModel.latestEpisodes.isEmpty, !composerModel.isLoading, composerModel.episode == nil {
////                            ComposerEpisodeSelector(composerModel: composerModel)
////                        }
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
                
            }.padding(15)
        }
    }
}
