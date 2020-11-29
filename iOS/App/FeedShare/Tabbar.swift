//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Tabbar: View {
    private let offsetHeight = CGFloat(0)
    
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var settingsVisible = false {
        didSet {
            withAnimation {
                self.offset = settingsVisible ? offsetHeight : 0
            }
        }
    }
    
    @State private var offset = CGFloat(0)
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if settingsVisible {
                    Color.black
                        .opacity(0.3)
                        .onTapGesture {
                            settingsVisible = false
                        }
                        .gesture(DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            self.offset = offsetHeight + gesture.translation.height
                                        }
                                    }
                                    .onEnded { gesture in
                                        if gesture.translation.height > 20 {
                                            self.settingsVisible = false
                                        } else {
                                            withAnimation {
                                                self.offset = offsetHeight
                                            }
                                        }
                                    }
                        )
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    Spacer()
                    VStack {
                        if settingsVisible {
                            let settingsBinding = Binding<Bool>(
                                get: {
                                    self.settingsVisible
                                },
                                set: {
                                    self.settingsVisible = $0
                                })
                            Settings(settingsVisible: settingsBinding)
                        } else {
                            HStack {
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "house.fill")
                                }.padding(10)
                                Spacer()
                                Button(action: {
                                    settingsVisible.toggle()
                                }) {
                                    Image(systemName: "person.fill")
                                }.padding(10)
                                Spacer()
                            }
                            .font(.headline)
                            .foregroundColor(Color.black)
                        }
                    }
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
                                    if settingsVisible {
                                        self.offset = offsetHeight + gesture.translation.height
                                    }
                                }
                                .onEnded { gesture in
                                    if gesture.translation.height > 20 {
                                        self.settingsVisible = false
                                    } else {
                                        withAnimation {
                                            self.offset = offsetHeight
                                        }
                                    }
                                }
                    )
                }
                .animation(.easeInOut(duration: 0.2))
            }
        }
    }
}
