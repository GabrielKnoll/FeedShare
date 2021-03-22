//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Apollo
import Combine
import Foundation
import SwiftUI

public class ComposerModel: ObservableObject {
    private var searchDebounce: AnyCancellable?
    private var searchCounter = 0

    public enum ComposerError {
        case none
        case urlNotFound
        case noURL
        case duplicateShare
        case shareFailed
    }

    @Published public var url: String = ""
    @Published public var searchResults: [ComposerPodcastFragment]?
    @Published public var latestEpisodes: [EpisodeAttachmentFragment]?
    @Published public var episode: EpisodeAttachmentFragment?
    @Published public var share: ShareFragment?
    @Published public var composerError: ComposerError = .none
    @Published public var searchText = "" {
        didSet {
            if searchText.isEmpty {
                searchResults = nil
            }
        }
    }

    @Published public var podcast: ComposerPodcastFragment? {
        didSet {
            if latestEpisodes == nil {
                getLatestEpisodes()
            }
        }
    }

    @Published public var isLoading: LoadingState = .none

    public enum LoadingState {
        case none
        case resolveUrl
        case createShare
        case latestEpisodes
        case findPodcastBlocking
        case findPodcastNonBlocking
    }

    init(url: String?) {
        searchDebounce = AnyCancellable(
            $searchText.removeDuplicates()
                .debounce(for: 0.8, scheduler: DispatchQueue.main)
                .sink { searchText in
                    self.findPodcast(query: searchText, isBlocking: false)
                })

        if let u = url {
            resolveUrl(url: u)
        }
    }

    func resolveUrl(url: String?) {
        composerError = .none
        if let u = url?.lowercased(), u.starts(with: "http://") || u.starts(with: "https://") {
            self.url = u
        } else {
            composerError = .noURL
            return
        }

        isLoading = .resolveUrl
        Network.shared.apollo.fetch(query: ResolveQuery(url: self.url),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case let .success(graphQLResult):
                if let episode = graphQLResult.data?.resolveShareUrl?.episode?.fragments.episodeAttachmentFragment {
                    self.episode = episode
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.isLoading = .none
                    }
                } else if let podcast = graphQLResult.data?.resolveShareUrl?.podcast?.fragments.composerPodcastFragment {
                    self.podcast = podcast
                    self.latestEpisodes = graphQLResult.data?.resolveShareUrl?.podcast?.latestEpisodes?.compactMap {
                        $0?.fragments.episodeAttachmentFragment
                    } ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.isLoading = .none
                    }
                } else {
                    self.composerError = .urlNotFound
                    self.isLoading = .none
                }
            case .failure:
                self.composerError = .urlNotFound
                self.episode = nil
                self.podcast = nil
                self.latestEpisodes = nil
                self.isLoading = .none
            }
        }
    }

    func getLatestEpisodes() {
        if let id = podcast?.id {
            isLoading = .latestEpisodes
            Network.shared.apollo.fetch(query: LatestEpisodesQuery(podcast: id),
                                        cachePolicy: .returnCacheDataAndFetch) { result in
                self.isLoading = .none
                switch result {
                case let .success(graphQLResult):
                    self.latestEpisodes = graphQLResult.data?.node?.asPodcast?.latestEpisodes?.compactMap {
                        $0?.fragments.episodeAttachmentFragment
                    }
                case .failure:
                    self.latestEpisodes = nil
                }
            }
        }
    }

    func findPodcast(query: String, isBlocking: Bool = true) {
        if query.lowercased().starts(with: "http://") || query.lowercased().starts(with: "https://") {
            if isBlocking {
                resolveUrl(url: query)
            }
            return
        }

        // cancel running request
        if searchText.count < 2 {
            isLoading = .none
            searchResults = nil
            return
        }
        let current = searchCounter + 1
        isLoading = isBlocking ? .findPodcastBlocking : .findPodcastNonBlocking
        Network.shared.apollo.fetch(query: FindPodcastQuery(query: query),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isLoading = .none
            switch result {
            case let .success(graphQLResult):
                if self.searchText.hasPrefix(query), current > self.searchCounter {
                    self.searchCounter = current
                    self.searchResults = graphQLResult.data?.typeaheadPodcast?.compactMap { $0?.fragments.composerPodcastFragment } ?? []
                }

            case .failure:
                self.searchResults = nil
            }
        }
    }

    func createShare(message: String!, shareOnTwitter: Bool, hideFromGlobalFeed: Bool) {
        isLoading = .createShare
        if let id = episode?.id {
            Network.shared.apollo.perform(mutation: CreateShareMutation(message: message,
                                                                        episodeId: id,
                                                                        shareOnTwitter: shareOnTwitter,
                                                                        hideFromGlobalFeed: hideFromGlobalFeed)) { result in
                self.isLoading = .none
                switch result {
                case let .success(graphQLResult):
                    if graphQLResult.errors?.first?.message == "P2002" {
                        self.composerError = .duplicateShare
                    } else if let share = graphQLResult.data?.createShare?.fragments.shareFragment {
                        self.share = share
                    } else {
                        self.composerError = .shareFailed
                    }
                case .failure:
                    print("createShare error: \(result)")
                    self.composerError = .shareFailed
                }
            }
        }
    }

    func reset() {
        searchResults = nil
        latestEpisodes = nil
        episode = nil
        podcast = nil
        isLoading = .none
    }
}
