//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct FeedStream: View {
    @StateObject var feedStreamModel = FeedStreamModel()

    public var body: some View {
        VStack {
            HStack {
                Text("Logo")
            }
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
        }
        .background(Color(R.color.background() ?? .gray))
        .edgesIgnoringSafeArea(.bottom)
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
