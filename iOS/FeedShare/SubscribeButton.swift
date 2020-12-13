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
    @State var showError = false
    let feed: String?
    
    func openURL(string: String?) {
        if let s = string, let url = URL(string: s) {
            UIApplication.shared.open(url) { success in
                if !success {
                    self.showError = true
                }
            }
        } else {
            showError = true
        }
    }
    
    public var body: some View {
        if let client = viewerModel.viewerClient {
            Button(action: {
                if !client.subscribeUrlNeedsProtocol, let feedUrl = URL(string: feed ?? "") {
                    let withoutProtocol = String(feedUrl.absoluteString.dropFirst((feedUrl.scheme?.count ?? -3) + 3))
                    openURL(string: client.subscribeUrl + withoutProtocol)
                } else if let f = feed {
                    openURL(string: client.subscribeUrl + f)
                } else {
                    showError = true
                }
            }) {
                Text("Subscribe in \(client.displayName)")
            }.disabled(feed == nil)
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
