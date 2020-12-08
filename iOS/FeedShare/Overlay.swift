//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Combine
import SwiftUI

enum OverlayView {
    case none
    case settings
    case composer
    case episode
}

class OverlayModel: ObservableObject {
    let objectWillChange = PassthroughSubject<OverlayModel, Never>()
    
    @Published public var active: OverlayView = .none {
        willSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
}

public struct Overlay<Content: View>: View {
    let content: (_ dismiss: @escaping () -> Void) -> Content
    private let position: OverlayPosition
    private let dismissable: Bool
    private let id: OverlayView
    
    @EnvironmentObject var overlayModel: OverlayModel
    @State private var offset = CGFloat(0)
    
    enum OverlayPosition {
        case top
        case bottom
    }
    
    init(
        id: OverlayView,
        position: OverlayPosition = .bottom,
        dismissable: Bool = true,
        @ViewBuilder content: @escaping (_ dismiss: @escaping () -> Void) -> Content
    ) {
        self.content = content
        self.position = position
        self.dismissable = dismissable
        self.id = id
    }
    
    private func ended(gesture: _ChangedGesture<DragGesture>.Value) {
        withAnimation {
            if (gesture.translation.height > 20 && position == .bottom) ||
                gesture.translation.height < -20 && position != .bottom {
                dismiss()
            } else {
                self.offset = 0
            }
        }
    }
    
    private func dismiss() {
        overlayModel.active = .none
        offset = 0
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                let visible = self.id == overlayModel.active
                if visible {
                    Color.black
                        .opacity(0.3)
                        .if(dismissable) {
                            $0.gesture(DragGesture()
                                        .onChanged { gesture in
                                            if gesture.translation.height > 0 {
                                                self.offset = gesture.translation.height
                                            }
                                        }
                                        .onEnded(ended)
                            ).onTapGesture {
                                dismiss()
                            }
                        }
                        .transition(.opacity)
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack(alignment: .bottom) {
                    if visible {
                        content(dismiss)
                            //.padding(.bottom, geometry.safeAreaInsets.bottom)
                            .background(Color.white)
                            .cornerRadius(38.5)
                            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)),
                                    radius: 5.0,
                                    x: 0.0,
                                    y: 0.0)
                            .offset(x: 0, y: offset)
                            .if(dismissable) {
                                $0.gesture(DragGesture()
                                            .onChanged { gesture in
                                                if visible {
                                                    self.offset = gesture.translation.height
                                                }
                                            }
                                            .onEnded(ended)
                                )
                            }
                            .transition(.move(edge: position == .bottom ? .bottom : .top))
                    }
                }
                .padding(10)
                //.animation(.interpolatingSpring(mass: 0.4, stiffness: 250, damping: 13))
            }.ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
