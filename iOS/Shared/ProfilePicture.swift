//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Combine
import SwiftUI
import URLImage

public struct ProfilePicture: View {
    private let size: CGFloat
    private let imageURL: URL?
    
    public init(url: String?, size: Double) {
        self.size = CGFloat(size)
        if let u = url {
            self.imageURL = URL(string: u)
        } else {
            self.imageURL = nil
        }
    }
    
    public var body: some View {
        if let url = self.imageURL {
            URLImage(url) {
                // This view is displayed before download starts
                EmptyView().skeleton(with: true)
            } inProgress: { _ in
                EmptyView().skeleton(with: true)
            } failure: { _,_  in
                EmptyView().skeleton(with: true)
            } content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: size, height: size)
            .background(Color.secondary)
            .cornerRadius(CGFloat(size / 2))
        }
    }
}
