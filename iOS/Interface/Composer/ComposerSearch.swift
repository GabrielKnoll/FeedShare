//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerSearch: View {
    enum ResolveError {
        case none
        case notFound
        case noURL
    }
    
    @State var unresolvedUrlAlert: ResolveError = .none
    @State var pastedString: String?
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    
    public var body: some View {
        let showError = Binding(
            get: { return unresolvedUrlAlert != .none },
            set: { _, _ in unresolvedUrlAlert = .none }
        )
        
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
                                print("episode")
                                self.navigationStack.push(ComposerMessage(composerModel: composerModel))
                            } else if composerModel.podcast != nil {
                                self.navigationStack.push(ComposerEpisode(composerModel: composerModel))
                            } else {
                                self.unresolvedUrlAlert = .notFound
                            }
                        }
                    } else {
                        self.unresolvedUrlAlert = .noURL
                    }
                }) {
                    Text("Paste from Clipboard")
                }
            }
            Spacer()
        }
        .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .alert(isPresented: showError) {
            Alert(
                title: {
                    switch unresolvedUrlAlert {
                    case .notFound: return Text("No Podcast Found")
                    case .noURL: return Text("No URL Found")
                    default: return Text("Error")
                    }
                }(),
                message: {
                    switch unresolvedUrlAlert {
                    case .notFound: return Text("We couldn't find a podcast at: \(pastedString ?? ""). Try finding the podcast you want to share using the search.")
                    case .noURL: return Text("You can paste a podcast's URL to share it.")
                    default: return Text("This didn't work. Please try again.")
                    }
                }(),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
