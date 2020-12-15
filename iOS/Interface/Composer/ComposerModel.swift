//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Apollo
import Combine
import Foundation

public class ComposerModel: ObservableObject {
    private var searchRequest: Apollo.Cancellable?
    private var searchDebounce: AnyCancellable?
    
    public var dismiss: (() -> Void)?
    @Published public var unresolvableURL: String?
    @Published public var searchResults: [ComposerPodcastFragment]?
    @Published public var latestEpisodes: [EpisodeAttachmentFragment]?
    @Published public var episode: EpisodeAttachmentFragment?
    @Published public var share: ShareFragment?
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
        case nonblocking
        case blocking
    }
    
    init() {
        searchDebounce = AnyCancellable(
            $searchText.removeDuplicates()
                .debounce(for: 0.8, scheduler: DispatchQueue.main)
                .sink { searchText in
                    self.findPodcast(searchText, isBlocking: false)
                })
    }
    
    func resolveUrl(url: String) {
        self.isLoading = .blocking
        Network.shared.apollo.fetch(query: ResolveQuery(url: url),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { result in
            self.isLoading = .none
            self.unresolvableURL = nil
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
                    self.unresolvableURL = url
                }
            case .failure:
                self.episode = nil
                self.podcast = nil
                self.latestEpisodes = nil
                self.unresolvableURL = url
            }
        }
    }
    
    func getLatestEpisodes() {
        if let id = podcast?.id {
            self.isLoading = .blocking
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
    
    func findPodcast(_ searchText: String, isBlocking: Bool = true) {
        // cancel running request
        searchRequest?.cancel()
        if searchText.isEmpty {
            return
        }
        self.isLoading = isBlocking ? .blocking : .nonblocking
        searchRequest = Network.shared.apollo.fetch(query: FindPodcastQuery(query: searchText),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isLoading = .none
            switch result {
            case let .success(graphQLResult):
                self.searchResults = graphQLResult.data?.typeaheadPodcast?.compactMap {
                    $0?.fragments.composerPodcastFragment
                } ?? []
            case .failure:
                self.searchResults = nil
            }
        }
    }
    
    func createShare(message: String!) {
        self.isLoading = .blocking
        if let id = episode?.id {
            Network.shared.apollo.perform(mutation: CreateShareMutation(message: message, episodeId: id)) { result in
                print(result)
                self.isLoading = .none
                switch result {
                case let .success(graphQLResult):
                    self.share = graphQLResult.data?.createShare?.fragments.shareFragment
                case .failure:
                    print(result)
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
