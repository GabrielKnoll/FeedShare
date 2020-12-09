//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Composer: View {
    @StateObject var composerModel = ComposerModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            NavigationStackView {
                ComposerSearch(composerModel: composerModel)
            }
        }.padding(20)
    }
}
