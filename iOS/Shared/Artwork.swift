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
    
    public init(url: String?, size: Double) {
        if let u = url, let uu = URL(string: u) {
            self.url = uu
        } else {
            self.url = nil
        }
        self.size = CGFloat(size)
    }
    
    let placeholder = Image(systemName: "antenna.radiowaves.left.and.right")
    
    public var body: some View {
        VStack {
            if let u = url {
                URLImage(
                    url: u,
                    inProgress: {_ in
                        placeholder
                    },
                    failure: {_, _ in
                        placeholder
                    },
                    content: { proxy in
                        proxy.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    })
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .background(Color.secondary)
        .cornerRadius(CGFloat(10))
    }
}
