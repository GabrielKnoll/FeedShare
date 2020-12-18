//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ActivityIndicator: UIViewRepresentable {
    public typealias UIViewType = UIActivityIndicatorView
    
    let style: UIActivityIndicatorView.Style
    
    public init(style: UIActivityIndicatorView.Style) {
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        return UIActivityIndicatorView(style: style)
    }
    
    public func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
  
}
