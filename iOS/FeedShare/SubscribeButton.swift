//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct SubscribeButton: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var showError = false
    
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
            UIApplication.shared.open(url, completionHandler: { success in
                if let cb = callback {
                    cb(success)
                }
            })
        }
    }
    
    public var body: some View {
        if let client = viewerModel.viewerClient {
            Button(action: {
                SubscribeButton.openURL(client, feed: feed) { success in
                    if !success {
                        showError = true
                    }
                    if let cb = self.callback {
                        cb(success)
                    }
                }
            }) {
                Text("Subscribe in \(client.displayName)")
            }
            .disabled(feed == nil)
            .alert(isPresented: $showError, content: {
                Alert(
                    title: Text("Unable to Subscribe"),
                    message: Text("\(client.displayName) could not be launched to subscribe to this podcast. Please make sure the app is installed."),
                    dismissButton: .default(Text("OK"))
                )
            })
        }
    }
}
