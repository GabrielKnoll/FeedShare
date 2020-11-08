//
//  FeedStreamViewModel.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Combine
import Foundation
import NetworkManager

public class ViewerModel: ObservableObject {
    private let networkManager: NetworkManager
    private var viewer: Viewer? {
        didSet {
            isLoggedIn = viewer != nil
            persistViewer()
        }
    }
    
    private let keychainQuery = [
        kSecAttrServer: "feedshare.com",
        kSecClass: kSecClassInternetPassword,
        kSecMatchLimit: kSecMatchLimitOne,
        kSecReturnAttributes: true,
        kSecReturnData: true
    ] as [CFString: Any]
    
    @Published public var isLoggedIn = false
    
    var signInCancellable: AnyCancellable?
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.viewer = self.restoreViewer()
        self.isLoggedIn = viewer != nil
    }
    
    private func persistViewer() {
        if let viewer = self.viewer {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(viewer), forKey: "viewer")
        } else {
            UserDefaults.standard.removeObject(forKey: "viewer")
        }
    }
    
    private func restoreViewer() -> Viewer? {
        if let data = UserDefaults.standard.value(forKey: "viewer") as? Data {
            return try? PropertyListDecoder().decode(Viewer.self, from: data)
        }
        return nil
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
