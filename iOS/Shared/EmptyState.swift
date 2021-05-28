//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct EmptyState: View {
    let title: String
    let message: String

    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack {
            Image(systemName: "binoculars")
                .font(.system(size: 30))
                .padding(.bottom, 2)
            Text(title)
                .font(Typography.bodyBold)
                .foregroundColor(Color(R.color.primaryColor.name))
                .padding(.bottom, 1)
            Text(message)
                .font(Typography.body)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .foregroundColor(Color(R.color.secondaryColor.name))
    }
}
