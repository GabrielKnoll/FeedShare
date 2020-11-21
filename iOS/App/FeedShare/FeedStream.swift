//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct FeedStream: View {
    @StateObject var feedStreamModel = FeedStreamModel()
    private let buttonAction = { print("profile pressed") }

    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: buttonAction) {
                Text("FeedShare")
            }
        }.frame(height: 70)
        RefreshableScrollView(refreshing: $feedStreamModel.loading) {
            LazyVStack {
                ForEach(feedStreamModel.shares.reversed(), id: \.node?.id) { edge in
                    if let fragment = edge.node?.fragments.shareFragment {
                        ShareRow(data: fragment, isEditable: false)
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

/*
 struct FeedStream_Previews: PreviewProvider {
 static var previews: some View {
 //FeedStream(feedStreamModel: FeedStreamModel())
 Text("test")
 }
 }
 */
