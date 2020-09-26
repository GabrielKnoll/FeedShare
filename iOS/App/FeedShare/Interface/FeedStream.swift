//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct FeedStream: View {
  private let buttonAction = { print("profile pressed") }
  @ObservedObject private var feedData: FeedData = FeedData()
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(0..<feedData.rows.count, id: \.self) { index in
            ShareRow(share: feedData.rows[index].node!)
              .padding()
              .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(R.color.background() ?? .white))
                            .padding()
                            .shadow(color: Color(R.color.dropShadow() ?? .gray),
                                    radius: 15,
                                    x: 10.0,
                                    y: 10.0))
          }
        }
        .navigationTitle("Feed")
        .navigationBarItems(trailing:
                              Button(action: buttonAction) {
                                Image("profile")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 35, height: 35, alignment: .center)
                                  .cornerRadius(18)
                              })
      }
      .background(Color(R.color.background() ?? .gray))
      .ignoresSafeArea(edges: .bottom)
    }
  }
}

class FeedData: ObservableObject {
  @Published var rows: [FeedStreamQuery.Data.Share.Edge] = []
  
  init() {
    self.rows = []
    loadData()
  }
  
  func loadData() {
    Network.shared.apollo.fetch(query: FeedStreamQuery()) { result in
      switch result {
      case .success(let graphQLResult):
        self.rows = graphQLResult.data?.shares.edges ?? []
      case .failure(let error):
        print("Failure! Error: \(error)")
      }
    }
  }
}
