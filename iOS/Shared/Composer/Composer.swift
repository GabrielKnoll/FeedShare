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
        NavigationStackView {
            ComposerSearch(composerModel: composerModel)
        }.onAppear(perform: {
            composerModel.dismiss = self.dismiss
        })
    }
}
