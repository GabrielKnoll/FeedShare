//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Interface
import SwiftUI

public struct SubscribeButton: View {
    @EnvironmentObject var viewerModel: ViewerModel
    let feed: String?
    let callback: Callback?
    
    typealias Callback = (Bool) -> Void
    
    init(feed: String?, callback: (Callback)? = nil) {
        self.feed = feed
        self.callback = callback
    }
    
    static func openURL(_ client: Client, feed: String?, callback: ((Bool) -> Void)? = nil) {
        var urlToOpen: String?
        if !client.subscribeUrlNeedsProtocol, let feedUrl = URL(string: feed ?? "") {
            let withoutProtocol = String(feedUrl.absoluteString.dropFirst((feedUrl.scheme?.count ?? -3) + 3))
            urlToOpen = client.subscribeUrl + withoutProtocol
        } else if let f = feed {
            urlToOpen = client.subscribeUrl + f
        }
        
        if let url = URL(string: urlToOpen ?? "") {
            UIApplication.shared.open(url, completionHandler: {success in
                let alertController = UIAlertController(
                    title: "Unable to Subscribe",
                    message: "\(client.displayName) could not be launched to subscribe to this podcast. Please make sure the app is installed.",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController?.present(
                    alertController,
                    animated: true,
                    completion: nil
                )
            })
        }
        
        if let cb = callback {
            cb(false)
        }
    }
    
    public var body: some View {
        if let client = viewerModel.viewerClient {
            Button(action: {
                SubscribeButton.openURL(client, feed: feed) { success in
                    if let cb = self.callback {
                        cb(success)
                    }
                }
            }) {
                Text("Subscribe in \(client.displayName)")
            }.disabled(feed == nil)
        }
    }
}
