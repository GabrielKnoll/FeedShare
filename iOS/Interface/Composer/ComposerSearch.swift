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
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    
    public var body: some View {
        VStack {
            SearchBar(text: $composerModel.searchText, action: composerModel.findPodcast)
                //.padding(.horizontal, -8)
                //.padding(.vertical, -10)
            if composerModel.isLoading {
                ActivityIndicator(style: .large)
            } else if let results = composerModel.searchResults {
                if results.isEmpty {
                    Text("No Results")
                } else {
                    ScrollView {
                        ForEach(results, id: \.id) { podcast in
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                composerModel.podcast = podcast
                                self.navigationStack.push(ComposerEpisode(composerModel: composerModel))
                            }) {
                                ComposerPodcast(podcast: podcast).padding(20)
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
                        composerModel.resolveUrl(url: url) {
                            if composerModel.episode != nil {
                                self.navigationStack.push(ComposerMessage(composerModel: composerModel))
                            } else if composerModel.podcast != nil {
                                self.navigationStack.push(ComposerEpisode(composerModel: composerModel))
                            } else {
                                self.unresolvedUrlAlert = true
                            }
                        }
                    } else {
                        self.unresolvedUrlAlert = true
                    }
                }) {
                    Text("Paste from Clipboard")
                }
            }
            Spacer()
        }
        .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .alert(isPresented: $unresolvedUrlAlert) {
            Alert(
                title: Text("Could not find"),
                message: Text("Could not find a podcast"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
