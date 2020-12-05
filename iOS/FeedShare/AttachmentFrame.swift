//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct AttachmentFrame<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            content
        }
        .frame(maxWidth: .infinity, minHeight: 65.0, alignment: .center)
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        .cornerRadius(15)
    }
}
