//
//  FeedStreamViewModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import NetworkManager
import Security

public class ViewerModel: ObservableObject {
    private let networkManager: NetworkManager
    private var viewer: Viewer?
    
    @Published public var isLoggedIn = false
    
    var signInCancellable: AnyCancellable?
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.viewer = nil
    }
    
    private func storeInKeychain() {
        let keychainItemQuery = [
            kSecValueData: "token".data(using: .utf8)!,
            kSecAttrAccount: "account",
            kSecAttrServer: "feedshare.com",
            kSecClass: kSecClassInternetPassword
        ] as CFDictionary
        let status = SecItemAdd(keychainItemQuery, nil)
        print("Operation finished with status: \(status)")
    }
    
    func twitterSignIn(
        twitterId: String,
        twitterToken: String,
        twitterTokenSecret: String
    ) {
        signInCancellable = networkManager.createViewer(twitterId, twitterToken, twitterTokenSecret)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.viewer = value
                    self.isLoggedIn = true
                  })
    }
    
}
