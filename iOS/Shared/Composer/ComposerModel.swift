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
    
    public enum ResolveError {
        case none
        case notFound
        case noURL
    }
    
    public var dismiss: (() -> Void)?
    @Published public var url: String = ""
    @Published public var searchResults: [ComposerPodcastFragment]?
    @Published public var latestEpisodes: [EpisodeAttachmentFragment]?
    @Published public var episode: EpisodeAttachmentFragment?
    @Published public var share: ShareFragment?
    @Published public var duplicateError = false
    @Published public var genericError = false
    @Published public var unresolvedUrlAlert: ResolveError = .none
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
    
    init() {
        searchDebounce = AnyCancellable(
            $searchText.removeDuplicates()
                .debounce(for: 0.8, scheduler: DispatchQueue.main)
                .sink { searchText in
                    self.findPodcast(query: searchText, isBlocking: false)
                })
    }
    
    func resolveUrl(url: String?) {
        unresolvedUrlAlert = .none
        if let u = url?.lowercased(), (u.starts(with: "http://") || u.starts(with: "https://")) {
            self.url = u
        } else {
            unresolvedUrlAlert = .noURL
            return
        }
        
        self.isLoading = .resolveUrl
        Network.shared.apollo.fetch(query: ResolveQuery(url: self.url),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { result in
            self.isLoading = .none
            switch result {
            case let .success(graphQLResult):
                if let episode = graphQLResult.data?.resolveShareUrl?.episode?.fragments.episodeAttachmentFragment {
                    self.episode = episode
                } else if let podcast = graphQLResult.data?.resolveShareUrl?.podcast?.fragments.composerPodcastFragment {
                    self.podcast = podcast
                    self.latestEpisodes = graphQLResult.data?.resolveShareUrl?.podcast?.latestEpisodes?.compactMap {
                        $0?.fragments.episodeAttachmentFragment
                    } ?? []
                } else {
                    self.unresolvedUrlAlert = .notFound
                }
            case .failure:
                self.unresolvedUrlAlert = .notFound
                self.episode = nil
                self.podcast = nil
                self.latestEpisodes = nil
            }
        }
    }
    
    func getLatestEpisodes() {
        if let id = podcast?.id {
            self.isLoading = .latestEpisodes
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
        } else {
            print("------------podcast id nil")
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
            self.isLoading = .none
            self.searchResults = nil
            return
        }
        let current = self.searchCounter + 1
        self.isLoading = isBlocking ? .findPodcastBlocking : .findPodcastNonBlocking
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
        self.isLoading = .createShare
        if let id = episode?.id {
            Network.shared.apollo.perform(mutation: CreateShareMutation(message: message,
                                                                        episodeId: id,
                                                                        shareOnTwitter: shareOnTwitter,
                                                                        hideFromGlobalFeed: hideFromGlobalFeed
            )) { result in
                self.isLoading = .none
                switch result {
                case let .success(graphQLResult):
                    if graphQLResult.errors?.first?.message == "P2002" {
                        self.duplicateError = true
                    } else if let share = graphQLResult.data?.createShare?.fragments.shareFragment {
                        self.share = share
                    } else {
                        self.genericError = true
                    }
                case .failure:
                    print(result)
                    self.genericError = true
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
