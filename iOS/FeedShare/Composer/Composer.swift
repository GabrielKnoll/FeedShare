//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Composer: View {
    @StateObject var composerModel = ComposerModel()
    //@Binding var visible: Bool
    
    public var body: some View {
        Overlay(id: .composer, position: .top, dismissable: false) {_ in 
            VStack {
                NavigationStackView {
                    ComposerSearch(composerModel: composerModel)
                }
            }.padding(20)
        }
    }
}
