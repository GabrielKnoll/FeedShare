//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Combine
import Interface
import SwiftUI

class OverlayModel: ObservableObject {
    let objectWillChange = PassthroughSubject<OverlayModel, Never>()
    
    @Published var alignment: OverlayAlignment = .bottom
    @Published var dismissable: Bool = true
    @Published public var presentedView: AnyView? {
        willSet {
            withAnimation(.custom()) {
                objectWillChange.send(self)
            }
        }
    }
    
    func present<Element: View>(
        _ element: Element,
        alignment: OverlayAlignment = .bottom,
        dismissable: Bool = true
    ) {
        self.presentedView = AnyView(element)
        self.alignment = alignment
        self.dismissable = dismissable
    }
}

enum OverlayAlignment {
    case top
    case bottom
}

public struct OverlayHost<Content: View>: View {
    @StateObject var overlayModel = OverlayModel()
    @State private var offset = CGFloat(0)
    let content: () -> Content
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    private func ended(gesture: _ChangedGesture<DragGesture>.Value) {
        if (gesture.translation.height > 20 && self.overlayModel.alignment == .bottom) ||
            gesture.translation.height < -20 && self.overlayModel.alignment != .bottom {
            dismiss()
            self.offset = 0
        } else {
            withAnimation(.custom()) {
                self.offset = 0
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.custom()) {
            self.overlayModel.presentedView = nil
        }
    }
    
    public var body: some View {
        ZStack {
            content()
            ZStack(alignment: self.overlayModel.alignment == .top ? .top : .bottom) {
                let visible: Bool = self.overlayModel.presentedView != nil
                
                if visible {
                    Color.black
                        .opacity(0.3)
                        .if(self.overlayModel.dismissable) {
                            $0.gesture(DragGesture()
                                        .onChanged { gesture in
                                            if gesture.translation.height > 0 {
                                                self.offset = gesture.translation.height
                                            }
                                        }
                                        .onEnded(ended)
                            ).onTapGesture { dismiss() }
                        }
                        .transition(.opacity)
                        .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        ZStack(alignment: .topTrailing) {
                            self.overlayModel.presentedView
                            Button(action: dismiss) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.title2)
                            }
                            .padding(19)
                        }
                        .background(Color.white)
                        .cornerRadius(38.5)
                        .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)),
                                radius: 5.0,
                                x: 0.0,
                                y: 0.0)
                        .offset(x: 0, y: offset)
                        .if(self.overlayModel.dismissable) {
                            $0.gesture(DragGesture()
                                        .onChanged { gesture in
                                            if visible {
                                                if gesture.translation.height < 0 {
                                                    let max = CGFloat(30)
                                                    let val = -gesture.translation.height
                                                    let o = log(max / 2 + val) - log(max / 2)
                                                    self.offset = o * -max
                                                } else {
                                                    self.offset = gesture.translation.height
                                                }
                                            }
                                        }
                                        .onEnded(ended)
                            )
                        }
                    }
                    .padding(10)
                    .transition(.move(edge: self.overlayModel.alignment == .bottom ? .bottom : .top))
                }
            }.ignoresSafeArea(.container, edges: .bottom)
        }.environmentObject(overlayModel)
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

extension Animation {
    static func custom() -> Animation {
        Animation.spring(response: 0.25, dampingFraction: 0.6)
    }
}
