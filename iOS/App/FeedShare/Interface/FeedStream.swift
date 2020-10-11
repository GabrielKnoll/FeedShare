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
          if let node = feedData.rows[feedData.rows.count - index - 1].node {
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
        fetchMore()
      }
    }
  }
  
  init() {
    self.rows = []
    loadData(cachePolicy: .returnCacheDataDontFetch)
    fetchMore()
  }
  
  func fetchMore() {
    Network.shared.apollo.store.withinReadTransaction({ transaction in
      let data = try transaction.read(
        query: FeedStreamQuery()
      )
      let cursor = data.shares.edges?.last??.cursor
      self.loadData(after: cursor, cachePolicy: .fetchIgnoringCacheCompletely)
    })
  }
  
  func loadData(after: String? = nil, cachePolicy: CachePolicy = .returnCacheDataAndFetch) {
    Network.shared.apollo.fetch(
      query: FeedStreamQuery(after: after),
      cachePolicy: cachePolicy
    ) { result in
      self.loading = false
      switch result {
      case .success(let graphQLResult):
        let result = graphQLResult.data?.shares.edges?.compactMap { $0 } ?? []
        self.rows.append(contentsOf: result)
        
        // manually update cache
        if (cachePolicy == .fetchIgnoringCacheCompletely) {
          Network.shared.apollo.store.withinReadWriteTransaction({ transaction in
            let query = FeedStreamQuery()
            try transaction.update(query: query) { (data: inout FeedStreamQuery.Data) in
              data.shares.edges?.append(contentsOf: result);
            }
          })
        }
        self.loading = false
      case .failure(let error):
        print("Failure! Error: \(error)")
      }
    }
  }
}