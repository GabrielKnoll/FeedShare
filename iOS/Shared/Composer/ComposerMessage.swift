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
    
    @State private var message = ""
    @State private var hideFromGlobalFeed = false
    @State private var shareOnTwitter = false
    
    init(composerModel: ComposerModel) {
        self.composerModel = composerModel
    }
    
    public var body: some View {
        let characterLimit = viewerModel.viewer?.messageLimit ?? 399
        
        ZStack {
            VStack {
                if let episode = composerModel.episode {
                    EpisodeAttachment(data: episode)
                }
                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text("What makes you love this episode?")
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    ComposerTextField(
                        text: $message,
                        limit: characterLimit,
                        disabled: composerModel.isLoading == .createShare
                    )
                }
                
                Text("\(message.count)/\(characterLimit)")
                    .font(.footnote)
                
                HStack {
                    Toggle(isOn: $shareOnTwitter, label: {
                        Text("Share on Twitter")
                    })
                    Toggle(isOn: $hideFromGlobalFeed, label: {
                        Text("Hide from Global Feed")
                    })
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
        .onDisappear(perform: {
            composerModel.episode = nil
        })
        .navigationBarItems(trailing:
                                Button("Publish") {
                                    composerModel.createShare(
                                        message: message,
                                        shareOnTwitter: shareOnTwitter,
                                        hideFromGlobalFeed: hideFromGlobalFeed
                                    )
                                }
                                .opacity(composerModel.isLoading == .createShare ? 0 : 1)
                                .background(
                                    composerModel.isLoading == .createShare
                                        ? ActivityIndicator(style: .medium)
                                        : nil)
                                .disabled(message.isEmpty || composerModel.isLoading == .createShare)
        )
    }
}

public extension Notification.Name {
    static let reloadFeed = Notification.Name(rawValue: "FeedStream.Reload")
}
