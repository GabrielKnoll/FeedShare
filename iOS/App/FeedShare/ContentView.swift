//
//  ContentView.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Network
import SwiftUI

struct ContentView: View {
    @ObservedObject private var launchData: LaunchListData = LaunchListData()

    var body: some View {
        Text(launchData.username)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class LaunchListData: ObservableObject {
    @Published var username: String

    init() {
        self.username = "I don't know who you are"
        loadData()
    }

    func loadData() {
        Network.shared.apollo.fetch(query: ContentViewQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let handle = graphQLResult.data?.viewer?.user?.handle {
                    self.username = handle
                    print(handle)
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
