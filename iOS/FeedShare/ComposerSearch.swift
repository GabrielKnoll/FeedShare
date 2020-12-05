//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerSearch: View {
    @State var unresolvedUrlAlert = false
    @State var pastedString: String?
    @State private var searchText = ""
    @ObservedObject var composerModel: ComposerModel
    
    public var body: some View {
        VStack {
            SearchBar(text: $searchText, action: composerModel.findPodcast)
            if composerModel.isResolving {
                ActivityIndicator(style: .large)
            } else if composerModel.isSearching {
                ActivityIndicator(style: .large)
            } else if let results = composerModel.searchResults, !results.isEmpty {
                List(results, id: \.id) { podcast in
                    ComposerPodcast(podcast: podcast)
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
        }.alert(isPresented: $unresolvedUrlAlert) {
            Alert(
                title: Text("Could not find"),
                message: Text("Could not find a podcast"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
