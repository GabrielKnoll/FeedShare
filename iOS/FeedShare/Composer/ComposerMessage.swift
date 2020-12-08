//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import NavigationStack
import SwiftUI
import URLImage

public struct ComposerMessage: View {
    @ObservedObject var composerModel: ComposerModel
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var message = ""
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    composerModel.createShare(message: message)
                }) {
                    Text("Publish")
                }
            }
            Spacer()
            if let episode = composerModel.episode {
                EpisodeAttachment(data: episode)
            }
        }
    }
}
