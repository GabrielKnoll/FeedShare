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
    
    public init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }.disabled(composerModel.isLoading == .createShare)
                Spacer()
                Text("Share Episode").fontWeight(.semibold)
                Spacer()
                
                Button(action: {
                    composerModel.createShare(message: composerModel.message)
                }) {
                    Text("Publish").fontWeight(.semibold)
                }
                .opacity(composerModel.isLoading == .createShare ? 0 : 1)
                .background(
                    composerModel.isLoading == .createShare
                        ? ActivityIndicator(style: .medium)
                        : nil)
                .disabled(composerModel.message.isEmpty || composerModel.isLoading == .createShare)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 16)
            Divider()
        }
        
        NavigationStackView {
            ComposerSearch(composerModel: composerModel)
        }.onAppear(perform: {
            composerModel.dismiss = self.dismiss
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
