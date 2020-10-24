//
//  FeedStreamViewModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import NetworkManager

public class FeedStreamViewModel: ObservableObject {
    @Published public var shareResults = [Share]()
    @Published public var loading = false {
        didSet {
            if oldValue == false && loading == true {
                loadAfterCursor()
            }
        }
    }
    
    private let networkManager: NetworkManager
    
    var feedRequestCancellable: AnyCancellable?
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        loadData()
    }
    
    private func loadAfterCursor() {
        loadData(after: shareResults.last?.cursor, fetchNew: true)
    }
    
    private func loadData(after: String? = nil, fetchNew: Bool = false) {
        if !loading { loading = true }
        feedRequestCancellable = networkManager
            .feedData(after, fetchNew)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] shares in
                    guard let self = self else { return }
                    if (fetchNew) {
                        self.shareResults.append(contentsOf: shares)
                    } else {
                        self.shareResults = shares
                    }
                    self.loading = false
                  })
    }
}
