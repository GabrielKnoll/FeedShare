//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct ShareRow: View {
  let share: FeedStreamQuery.Data.Share.Edge.Node
  private let buttonAction = { print("button pressed") }
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center, spacing: 15) {
        Image("profile")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 30, height: 30, alignment: .center)
          .cornerRadius(15)
        Text(share.fragments.row.author.handle)
          .font(.headline)
        Spacer()
        Button(action: buttonAction) {
          Image(systemName: "ellipsis")
        }
        .padding()
        .foregroundColor(.black)
        .font(.headline)
      }
      
      Text(share.fragments.row.message ?? "")
      HStack(alignment: .center, spacing: 15) {
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 55, height: 55, alignment: .center)
          .cornerRadius(15)
        VStack(alignment: .leading, spacing: 3) {
          Text(share.fragments.row.attachment?.title ?? "Title")
            .font(.headline)
          Text("Subtitle")
            .font(.subheadline)
            .foregroundColor(.secondary)
          HStack {
            Image(systemName: "clock")
            Text("Duration")
          }
          .foregroundColor(.secondary)
          .font(.caption)
        }
        Spacer()
      }
      Spacer()
    }
    .padding()
  }
}


