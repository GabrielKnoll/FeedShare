//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

public struct Tabbar: View {
    private let height = CGFloat(80)
    private let offsetHeight = CGFloat(400)
    
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var settingsVisible = false {
        didSet {
            withAnimation {
                self.offset = settingsVisible ? -offsetHeight : 0
            }
        }
    }
    
    @State private var offset = CGFloat(0)
    
    public var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                if settingsVisible {
                    Button(action: {
                        settingsVisible = false
                    }, label: {
                        Text("test")
                    })
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.black)
                    .opacity(0.1)
                }
            }
            .animation(.easeInOut(duration: 0.2))
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "house.fill")
                    }
                    Spacer()
                    Button(action: {
                        settingsVisible.toggle()
                    }) {
                        Image(systemName: "person.fill")
                    }
                    Spacer()
                    Button(action: {
                        viewerModel.logout()
                    }) {
                        Text("Logout")
                    }
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(Color.black)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .frame(width: geometry.size.width, height: height)
                
                if settingsVisible {
                    VStack {
                        Text("Settings 1")
                        Text("Settings 2")
                        Text("Settings 3")
                        Text("Settings 4")
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)),
                    radius: 5.0,
                    x: 0.0,
                    y: 0.0)
            .frame(width: geometry.size.width, height: height, alignment: .top)
            .fixedSize()
            .position(x: geometry.size.width / 2, y: geometry.size.height)
            .offset(x: 0, y: offset)
            .gesture(DragGesture()
                        .onChanged { gesture in
                            if settingsVisible {
                                self.offset = gesture.translation.height - offsetHeight
                            }
                        }
                        .onEnded { gesture in
                            if (gesture.translation.height > 20) {
                                self.settingsVisible = false
                            }
                        }
            )
            
        }
    }
}
