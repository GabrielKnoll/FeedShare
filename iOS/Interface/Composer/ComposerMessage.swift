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
    
    init(composerModel: ComposerModel) {
        self.composerModel = composerModel
    }
    
    public var body: some View {
        let characterLimit = viewerModel.viewer?.messageLimit ?? 399
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
                set: { value in
                    if value.count <= characterLimit {
                        self.message = value
                    }
                }
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
