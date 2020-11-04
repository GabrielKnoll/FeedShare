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
            let token = viewer.token.data(using: .utf8)!
            
            let updateFields = [
                kSecAttrAccount: viewer.id,
                kSecValueData: token
            ] as [CFString: Any]
            
            var status = SecItemUpdate(keychainQuery as CFDictionary, updateFields as CFDictionary)
            if status == errSecItemNotFound {
                status = SecItemAdd(keychainQuery.merging(updateFields) { (_, new) in new } as CFDictionary, nil)
            }
            
            print("Operation finished with status: \(status)")
        } else {
            SecItemDelete(keychainQuery as CFDictionary)
        }
    }
    
    private func restoreViewer() -> Viewer? {
        var item: CFTypeRef?
        SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        
        if let existingItem = item as? [String: Any],
           let tokenData = existingItem[kSecValueData as String] as? Data,
           let token = String(data: tokenData, encoding: String.Encoding.utf8),
           let id = existingItem[kSecAttrAccount as String] as? String {
            return Viewer(id: id, token: token, handle: "todo")
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
