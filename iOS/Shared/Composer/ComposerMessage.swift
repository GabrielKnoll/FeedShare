//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct ComposerMessage: View {
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    @EnvironmentObject private var viewerModel: ViewerModel
    
    init(composerModel: ComposerModel) {
        self.composerModel = composerModel
    }
    
    public var body: some View {
        let characterLimit = viewerModel.viewer?.messageLimit ?? 399
        
        ZStack {
            VStack {
                ComposerTextField(
                    text: $composerModel.message,
                    limit: characterLimit,
                    disabled: composerModel.isLoading == .createShare
                )
                
                Text("\(composerModel.message.count)/\(characterLimit)")
                    .font(.footnote)
                
                if let episode = composerModel.episode {
                    EpisodeAttachment(data: episode)
                }
            }.padding(20)
            .onReceive(composerModel.$share) { share in
                if let s = share {
                    NotificationCenter.default.post(name: .reloadFeed, object: s)
                    if let d = composerModel.dismiss {
                        d()
                    }
                }
            }
            
            if composerModel.isLoading == .createShare {
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .opacity(0.1)
            }
        }
        
    }
}

public extension Notification.Name {
    static let reloadFeed = Notification.Name(rawValue: "FeedStream.Reload")
}
