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
    
    init(url: String?, size: Double) {
        self.url = URL(string: url!)
        self.size = CGFloat(size)
    }
    
    public var body: some View {
        URLImage(
            url: url!,
            inProgress: {_ in
                Image(systemName: "circle")
            },
            failure: {_, _ in
                Image(systemName: "circle")
            },
            content: { proxy in
                proxy.resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }).frame(width: size, height: size).cornerRadius(CGFloat(10))
    }
}
