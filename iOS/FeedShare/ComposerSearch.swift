//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NavigationStack
import SwiftUI
import URLImage

public struct ComposerSearch: View {
    @State var unresolvedUrlAlert = false
    @State var pastedString: String?
    @State private var searchText = "" {
        didSet {
            if searchText.isEmpty {
                composerModel.searchResults = nil
            }
        }
    }
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject var navigationStack: NavigationStack
    
    public var body: some View {
        VStack {
            SearchBar(text: $searchText, action: composerModel.findPodcast)
                .padding(.horizontal, -8)
                .padding(.vertical, -10)
            if composerModel.isResolving {
                ActivityIndicator(style: .large)
            } else if composerModel.isSearching {
                ActivityIndicator(style: .large)
            } else if let results = composerModel.searchResults {
                if results.isEmpty {
                    Text("No Results")
                } else {
                    ScrollView {
                        ForEach(results, id: \.id) { podcast in
                            Button(action: {
                                composerModel.podcast = podcast
                                self.navigationStack.push(ComposerEpisode(composerModel: composerModel))
                            }) {
                                ComposerPodcast(podcast: podcast)
                            }
                        }
                    }
                }
            } else {
                Text("Search for a Podcast you like to share or paste a link")
                    .multilineTextAlignment(.center)
                Button(action: {
                    self.pastedString = UIPasteboard.general.string
                    if let url = self.pastedString, url.lowercased().hasPrefix("http") {
                        composerModel.resolveUrl(url: url)
                    } else {
                        self.unresolvedUrlAlert = true
                    }
                }) {
                    Text("Paste from Clipboard")
                }
            }
            Spacer()
        }
        .padding(20)
        .alert(isPresented: $unresolvedUrlAlert) {
            Alert(
                title: Text("Could not find"),
                message: Text("Could not find a podcast"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
