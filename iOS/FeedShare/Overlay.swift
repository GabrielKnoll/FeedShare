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
    
    @Published var position: OverlayPosition = .bottom
    @Published var dismissable: Bool = true
    @Published public var presentedView: AnyView? {
        willSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
    
    func present<Element: View>(
        _ element: Element,
        position: OverlayPosition = .bottom,
        dismissable: Bool = true
    ) {
        self.presentedView = AnyView(element)
        self.position = position
        self.dismissable = dismissable
    }
}

enum OverlayPosition {
    case top
    case bottom
}

public struct OverlayHost<Content: View>: View {
    @StateObject var overlayModel = OverlayModel()
    let content: () -> Content
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
            Overlay()
        }.environmentObject(overlayModel)
    }
}

public struct Overlay: View {
    @EnvironmentObject var overlayModel: OverlayModel
    @State private var offset = CGFloat(0)
    
    private func ended(gesture: _ChangedGesture<DragGesture>.Value) {
            if (gesture.translation.height > 20 && self.overlayModel.position == .bottom) ||
                gesture.translation.height < -20 && self.overlayModel.position != .bottom {
                dismiss()
            } else {
                withAnimation {
                    self.offset = 0
                }
            }
    }
    
    private func dismiss() {
        offset = 0
        withAnimation {
            self.overlayModel.presentedView = nil
        }
    }
    
    public var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .bottom) {
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
                            ).onTapGesture {
                                dismiss()
							}
                        }
                        .transition(.opacity)
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack(alignment: .bottom) {
                    if visible {
                        ZStack(alignment: .topTrailing) {
                            self.overlayModel.presentedView
                            Button(action: dismiss) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.title2)
                            }.padding(19)
                        }//.padding(.bottom, geometry.safeAreaInsets.bottom)
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
                        .transition(.move(edge: self.overlayModel.position == .bottom ? .bottom : .top))
                    }
                }
                .padding(10)
                .animation(.spring(response: 0.25, dampingFraction: 0.6))
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
