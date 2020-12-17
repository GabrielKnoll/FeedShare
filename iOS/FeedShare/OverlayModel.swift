//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Combine
import Shared
import SwiftUI

class OverlayModel: ObservableObject {
    let objectWillChange = PassthroughSubject<OverlayModel, Never>()
    
    @Published public var presentedView: AnyView?
    @Published public var visible: Bool = false {
        willSet { objectWillChange.send(self) }
        didSet {
            if !visible {
                presentedView = nil
            }
        }
    }
    
    func present<Element: View>(view: Element) {
        self.presentedView = AnyView(view)
        visible = true
    }
}
