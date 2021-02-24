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
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                }
                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text("What makes you love this episode?")
                            .font(Typography.body)
                            .foregroundColor(Color(R.color.secondaryColor.name))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    ComposerTextField(
                        text: $message,
                        limit: characterLimit,
                        disabled: composerModel.isLoading == .createShare
                    )
                }
                .padding(.horizontal, 17)
                
                VStack(spacing: 10) {
                    Divider().background(Color(R.color.tertiaryColor.name))
                    
                    Toggle(isOn: $shareOnTwitter, label: {
                        Text("Share on Twitter")
                            .font(Typography.caption)
                            .foregroundColor(Color(shareOnTwitter ? R.color.primaryColor.name : R.color.secondaryColor.name))
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color(R.color.brandColor.name)))
                    .padding(.horizontal, 20)
                    
                    Divider().background(Color(R.color.tertiaryColor.name))
                    
                    Toggle(isOn: $hideFromGlobalFeed, label: {
                        Text("Hide from Global Feed")
                            .font(Typography.caption)
                            .foregroundColor(Color(hideFromGlobalFeed ? R.color.primaryColor.name : R.color.secondaryColor.name))
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color(R.color.brandColor.name)))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
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
                    .foregroundColor(Color(R.color.lightWashColor.name))
                    .opacity(0.5)
            }
        }
        .foregroundColor(Color(R.color.primaryColor.name))
        .onDisappear(perform: {
            composerModel.episode = nil
        })
        .navigationBarItems(trailing:
                                Button("Publish") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    composerModel.createShare(
                                        message: message,
                                        shareOnTwitter: shareOnTwitter,
                                        hideFromGlobalFeed: hideFromGlobalFeed
                                    )
                                }
                                .foregroundColor(Color(message.isEmpty ? R.color.secondaryColor.name : R.color.primaryColor.name))
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
