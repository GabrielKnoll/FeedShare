//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Overlay<Content: View>: View {
    let content: () -> Content
    
    @EnvironmentObject var viewerModel: ViewerModel
    @Binding var visible: Bool {
        willSet {
            if !newValue {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        didSet {
            self.offset = 0
        }
    }
    @State private var offset = CGFloat(0)
    
    init(visible: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._visible = visible
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if $visible.wrappedValue {
                    Color.black
                        .opacity(0.3)
                        .onTapGesture {
                            withAnimation {
                                visible.toggle()
                            }
                        }
                        .gesture(DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            self.offset = gesture.translation.height
                                        }
                                    }
                                    .onEnded { gesture in
                                        withAnimation {
                                            if gesture.translation.height > 20 {
                                                visible.toggle()
                                            } else {
                                                self.offset = 0
                                            }
                                        }
                                    }
                        )
                        .transition(.opacity)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    Spacer()
                    if $visible.wrappedValue {
                        content()
                            .edgesIgnoringSafeArea(.bottom)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)),
                                    radius: 5.0,
                                    x: 0.0,
                                    y: 0.0)
                            .offset(x: 0, y: offset + geometry.safeAreaInsets.bottom)
                            .gesture(DragGesture()
                                        .onChanged { gesture in
                                            if $visible.wrappedValue {
                                                self.offset = gesture.translation.height
                                            }
                                        }
                                        .onEnded { gesture in
                                            withAnimation {
                                                if gesture.translation.height > 20 {
                                                    visible.toggle()
                                                } else {
                                                    self.offset = 0
                                                }
                                            }
                                        }
                            )
                            .transition(.move(edge: .bottom))
                    }
                }.animation(.interpolatingSpring(mass: 0.4, stiffness: 250, damping: 13))
            }
        }
    }
}
