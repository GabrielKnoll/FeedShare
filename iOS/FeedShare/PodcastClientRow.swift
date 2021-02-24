//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct PodcastClientRow: View {
    let icon: String?
    let name: String
    let action: () -> Void
    
    public var body: some View {
        Button(action: self.action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if let i = icon {
                        Artwork(url: i, size: 44.0)
                    }
                    Text(name)
                        .font(Typography.button)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(Color(R.color.secondaryColor.name))
                }
                .frame(height: 64)
                .foregroundColor(Color(R.color.primaryColor.name))
                Divider().background(Color(R.color.tertiaryColor.name))
            }
        }
    }
}
