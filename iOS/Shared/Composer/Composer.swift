//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Composer: View {
    @StateObject var composerModel = ComposerModel()
    let dismiss: () -> Void
    
    @State var screen: Int?
    
    public init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                
                ComposerSearch(composerModel: composerModel)
                    .navigationBarTitle(screen == nil ? "Search Podcast" : "Search", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Button("Cancel", action: self.dismiss)
                                            .font(.system(size: 17, weight: .regular))
                    )
                
                NavigationLink(
                    destination: ComposerEpisode(composerModel: composerModel),
                    tag: 1,
                    selection: $screen
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: ComposerMessage(composerModel: composerModel),
                    tag: 2,
                    selection: $screen
                ) {
                    EmptyView()
                }
            }
        }
        .onAppear(perform: {
            composerModel.dismiss = self.dismiss
        })
        .onReceive(composerModel.$episode, perform: {episode in
            if composerModel.podcast == nil, episode != nil {
                print("2")
                self.screen = 2
            }
        })
        .onReceive(composerModel.$podcast, perform: {podcast in
            if podcast != nil {
                print("1")
                self.screen = 1
            }
        })
        .alert(isPresented: $composerModel.duplicateError, content: {
            Alert(
                title: Text("Episode Already Shared"),
                message: Text("You have already shared this episode. Every episode can only be shared once."),
                dismissButton: .default(Text("OK"))
            )
        })
        .alert(isPresented: $composerModel.genericError, content: {
            Alert(
                title: Text("Sharing Episode Failed"),
                message: Text("There was a problem sharing the episode. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        })
    }
}
