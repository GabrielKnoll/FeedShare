//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Composer: View {
    @StateObject var composerModel: ComposerModel
    let dismiss: (_ success: Bool) -> Void
    
    @State var screen: Int?
    
    public init(dismiss: @escaping (_ success: Bool) -> Void, url: String? = nil) {
        self.dismiss = dismiss
        _composerModel = StateObject(wrappedValue: ComposerModel(url: url))
    }
    
    public var body: some View {
        let showError = Binding(
            get: { composerModel.composerError != .none },
            set: { _, _ in composerModel.composerError = .none }
        )
        
        NavigationView {
            VStack {
                ComposerSearch(composerModel: composerModel)
                    .navigationBarTitle(screen == nil ? "Share Podcast" : "Search", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Button("Cancel", action: {
                                                self.dismiss(false)
                                            })
                                            .font(Typography.body)
                                            .padding(.vertical, 12)
                    )
                
                // this fixes a problem with iOS 14.5 popping views immediately after pushing, nobody knows why
                // https://forums.swift.org/t/14-5-beta3-navigationlink-unexpected-pop/45279
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                
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
        .onReceive(composerModel.$episode, perform: { episode in
            if composerModel.podcast == nil, episode != nil {
                self.screen = 2
            }
        })
        .onReceive(composerModel.$podcast, perform: { podcast in
            if podcast != nil {
                self.screen = 1
            }
        })
        .onReceive(composerModel.$share) { share in
            if let s = share {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss(true)
                }
            }
        }
        .alert(isPresented: showError) {
            Alert(
                title: {
                    switch composerModel.composerError {
                    case .urlNotFound: return Text("No Podcast Found")
                    case .noURL: return Text("No URL Found")
                    case .duplicateShare: return Text("Episode Already Shared")
                    case .shareFailed: return Text("Sharing Episode Failed")
                    default: return Text("Error")
                    }
                }(),
                message: {
                    switch composerModel.composerError {
                    case .urlNotFound: return Text("We couldn't find a podcast at \(composerModel.url). Try finding the podcast you want to share using search.")
                    case .noURL: return Text("You can paste a podcast's URL to share it.")
                    case .duplicateShare: return Text("You have already shared this episode. Every episode can only be shared once.")
                    case .shareFailed: return Text("There was a problem sharing the episode. Please try again.")
                        
                    default: return Text("This didn't work. Please try again.")
                    }
                }(),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
