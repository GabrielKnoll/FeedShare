//
//  FeedStreamModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import Apollo

public class ComposerModel: ObservableObject {
    private var searchRequest: Apollo.Cancellable?
    private var searchDebounce: AnyCancellable?
    @Published public var searchResults: [ComposerPodcastFragment]?
    @Published public var latestEpisodes: [EpisodeAttachmentFragment]?
    @Published public var episode: EpisodeAttachmentFragment?
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
    @Published public var isLoading: Bool = false
    
    init() {
        searchDebounce = AnyCancellable(
            $searchText.removeDuplicates()
                .debounce(for: 0.8, scheduler: DispatchQueue.main)
                .sink { searchText in
                    self.findPodcast(searchText)
                })
    }
    
    func resolveUrl(url: String, resultHandler: @escaping () -> Void) {
        self.isLoading = true
        Network.shared.apollo.fetch(query: ResolveQuery(url: url),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isLoading = false
            switch result {
            case let .success(graphQLResult):
                self.episode = graphQLResult.data?.resolveShareUrl?.episode?.fragments.episodeAttachmentFragment
                if self.episode == nil {
                    self.podcast = graphQLResult.data?.resolveShareUrl?.podcast?.fragments.composerPodcastFragment
                    self.latestEpisodes = graphQLResult.data?.resolveShareUrl?.podcast?.latestEpisodes?.compactMap {
                        $0?.fragments.episodeAttachmentFragment
                    } ?? []
                }
            case .failure:
                self.episode = nil
                self.podcast = nil
                self.latestEpisodes = nil
            }
            resultHandler()
        }
    }
    
    func getLatestEpisodes() {
        if let id = podcast?.id {
            self.isLoading = true
            Network.shared.apollo.fetch(query: LatestEpisodesQuery(podcast: id),
                                        cachePolicy: .returnCacheDataAndFetch) { result in
                self.isLoading = false
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
    
    func findPodcast(_ searchText: String) {
        // cancel running request
        searchRequest?.cancel()
        if searchText.isEmpty {
            return
        }
        self.isLoading = true
        searchRequest = Network.shared.apollo.fetch(query: FindPodcastQuery(query: searchText),
                                    cachePolicy: .returnCacheDataAndFetch) { result in
            self.isLoading = false
            switch result {
            case let .success(graphQLResult):
                self.searchResults = graphQLResult.data?.findPodcast?.compactMap {
                    $0?.fragments.composerPodcastFragment
                } ?? []
            case .failure:
                self.searchResults = nil
            }
        }
    }
    
    func createShare(message: String!) {
        self.isLoading = true
        if let id = episode?.id {
            Network.shared.apollo.perform(mutation: CreateShareMutation(message: message, episodeId: id)) { result in
                print(result)
                self.isLoading = false
                switch result {
                case let .success(graphQLResult):
                    print(graphQLResult.data?.createShare?.fragments.shareFragment ?? "")
                case .failure:
                    print("error")
                }
            }
        }
    }
    
    func reset() {
        searchResults = nil
        latestEpisodes = nil
        episode = nil
        podcast = nil
        isLoading = false
    }
}
