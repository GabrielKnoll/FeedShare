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
    private let characterLimit: Int
    
    init(composerModel: ComposerModel) {
        self.characterLimit = /*viewerModel.viewer?.messageLimit ??*/ 399
        self.composerModel = composerModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    composerModel.createShare(message: message)
                }) {
                    Text("Publish")
                }.disabled(message.isEmpty)
            }
            
            let binding = Binding(
                get: { self.message },
                set: { if $0.count <= characterLimit {
                    self.message = $0
                } }
            )
            TextEditor(text: binding)
                .foregroundColor(.black)
                .border(Color.secondary.opacity(0.2))
                .cornerRadius(15)
            
            Text("\(message.count)/\(characterLimit)")
                .font(.footnote)
            
            if let episode = composerModel.episode {
                EpisodeAttachment(data: episode)
            }
        }.padding(20)
    }
}
