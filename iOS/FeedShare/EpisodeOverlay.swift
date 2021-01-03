//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SkeletonUI
import SwiftUI

public struct EpisodeOverlay: View {
    let attachment: EpisodeAttachmentFragment
    
    @ObservedObject var data: EpisodeOverlayModel
    @EnvironmentObject var viewerModel: ViewerModel
    @State var isLoaded = true
    
    init(attachment: EpisodeAttachmentFragment) {
        self.attachment = attachment
        self.data = EpisodeOverlayModel(id: attachment.id)
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                Artwork(url: self.data.artwork ?? self.attachment.artwork, size: 100)
                Text(attachment.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text(attachment.podcast.title)
                    .multilineTextAlignment(.center)
                Text(attachment.podcast.publisher)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                let numberOfLines = 10
                
                Text(data.description)
                    .transition(.identity)
                    .padding(0)
                    .font(.system(size: 15))
                    .lineLimit(numberOfLines)
                    .skeleton(with: data.description == nil)
                    .shape(type: .capsule)
                    .multiline(lines: numberOfLines, scales: [
                        0: 0.85,
                        1: 0.91,
                        2: 0.82,
                        3: 0.95,
                        4: 0.73,
                        5: 0.87,
                        6: 0.82,
                        7: 0.90,
                        8: 0.95,
                        9: 0.88
                    ])
                    .frame(height: 18.0 * CGFloat(numberOfLines))
                
                SubscribeButton(feed: data.feed)
                    .buttonStyle(FilledButton())
                    .padding(.top, 15)
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .padding(15)
        }
        .frame(maxHeight: 440)
        
    }
}
