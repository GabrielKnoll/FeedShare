//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import Apollo

struct FeedStream: View {
    private let buttonAction = { print("profile pressed") }
    @ObservedObject private var feedData: FeedData = FeedData()
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: buttonAction) {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35, alignment: .center)
                    .cornerRadius(18)
            }
        }.frame(height: 70)
        RefreshableScrollView(refreshing: self.$feedData.loading) {
            LazyVStack {
                ForEach(0..<feedData.rows.count, id: \.self) { index in
                    if let node = feedData.rows[index].node {
                        ShareRow(data: node.fragments.shareFragment)
                            .padding(.top, 5)
                            .padding(.trailing, 15)
                            .padding(.leading, 15)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 25)
            
        }
        .background(Color(R.color.background() ?? .gray))
        .ignoresSafeArea(edges: .vertical)
    }
}

class FeedData: ObservableObject {
    @Published var rows: [FeedStreamQuery.Data.Share.Edge] = []
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                //self.loading = true
                print("load data")
                loadData(before: self.rows.first?.cursor, cachePolicy: .fetchIgnoringCacheData)
                
            }
        }
    }
    
    init() {
        self.rows = []
        loadData()
    }
    
    func loadData(before: String? = nil, cachePolicy: CachePolicy = .returnCacheDataAndFetch) {
        Network.shared.apollo.fetch(query: FeedStreamQuery(before: before), cachePolicy: cachePolicy) { result in
            switch result {
            case .success(let graphQLResult):
                print(graphQLResult.data?.shares.edges?.count)
                print(self.rows.count)
                self.rows = graphQLResult.data?.shares.edges ?? [] + self.rows
                //self.loading = false
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
