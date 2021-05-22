//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerSearch: View {
    @State var pastedString: String?
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject private var navigationStack: NavigationStack

    public var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SearchBar(
                text: composerModel.isLoading == .resolveUrl ? $composerModel.url : $composerModel.searchText,
                disabled: composerModel.isLoading == .findPodcastBlocking || composerModel.isLoading == .resolveUrl,
                placeholder: "Search Podcasts...",
                focused: composerModel.composerError == .none
            ) {
                composerModel.findPodcast(query: composerModel.searchText)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)

            if composerModel.isLoading == .findPodcastBlocking {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            } else if composerModel.isLoading == .resolveUrl {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            } else if let results = composerModel.searchResults, !results.isEmpty {
                ScrollView {
                    ForEach(results, id: \.id) { podcast in
                        Button(action: {
                            composerModel.podcast = podcast
                        }) {
                            ComposerPodcast(podcast: podcast)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(RowButton())
                        .padding(.horizontal, 20)
                    }
                }
            } else if composerModel.isLoading != .none {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            } else if composerModel.searchText.count > 1 && composerModel.searchResults?.isEmpty == true {
                Spacer()
                EmptyState(
                    title: "No Results",
                    message: "We couldn't find any podcast with this name."
                )
                Spacer()
            } else {
                Button(action: {
                    composerModel.resolveUrl(url: UIPasteboard.general.string)
                }) {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "doc.on.doc.fill")
                            .foregroundColor(Color(R.color.primaryColor.name))
                            .frame(maxHeight: 20)
                        Text("Paste from Clipboard")
                            .foregroundColor(Color(R.color.primaryColor.name))
                            .font(Typography.bodyMedium)
                    }
                }
                .buttonStyle(LinkButton())

                Spacer()
            }
        }
        .foregroundColor(Color(R.color.primaryColor.name))
    }
}
