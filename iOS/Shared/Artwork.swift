//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct Artwork: View {
    private let url: URL?
    private let size: CGFloat
    @State private var loading = true

    public init(url: String?, size: Double) {
        if let u = url, let uu = URL(string: u) {
            self.url = uu
        } else {
            self.url = nil
        }
        self.size = CGFloat(size)
    }

    public var body: some View {
        VStack {
            if let u = url {
                URLImage(
                    url: u,
                    inProgress: { _ in
                        Rectangle()
                            .skeleton(with: true)
                            .shape(type: .rectangle)
                    },
                    failure: { _, _ in
                        Rectangle()
                            .fill(Color(R.color.washColor.name))
                    },
                    content: { proxy in
                        proxy
                            .resizable()
                            .clipped()
                    }
                )
            } else {
                Rectangle()
                    .fill(Color(R.color.washColor.name))
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(CGFloat(10))
    }
}
