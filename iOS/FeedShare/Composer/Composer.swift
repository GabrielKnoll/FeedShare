//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct Composer: View {
    @Binding var visible: Bool
    @StateObject var composerModel = ComposerModel()
    
    public var body: some View {
        Overlay(visible: $visible) {
            VStack {
                NavigationStackView {
                    ComposerSearch(composerModel: composerModel)
                }
            }.padding(20)
        }
    }
}
