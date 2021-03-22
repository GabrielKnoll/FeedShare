//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import MarkdownUI
import Shared
import SwiftUI

public struct MarkdownPage: View {
    let content: String

    public var body: some View {
        ScrollView {
            Markdown(Document(content))
                .markdownStyle(
                    DefaultMarkdownStyle(
                        font: R.font.interRegular(size: 16.0)!,
                        foregroundColor: R.color.primaryColor()!
                    )
                )
                .accentColor(Color(R.color.brandColor.name))
                .padding(14.5)
        }
    }
}
