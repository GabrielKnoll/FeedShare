//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct FeedStream: View {
    @StateObject var feedStreamModel = FeedStreamModel()
    @State private var feedType = 0
    
    public var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("LOGO").font(.headline)
                    Spacer()
                    Button(action: {}) {
                        Text("Create")
                    }
                }.padding(15)
                Picker(selection: $feedType, label: Text("What is your favorite color?")) {
                    Text("Friends").tag(0)
                    Text("Personal").tag(1)
                    Text("Global").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
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
