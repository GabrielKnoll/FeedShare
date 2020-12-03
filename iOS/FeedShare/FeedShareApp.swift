//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

@main
struct FeedShareApp: App {
    @ObservedObject var viewerModel = ViewerModel.shared
    @State private var settingsVisible = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if viewerModel.initialized {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        FeedStream()
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "house.fill")
                                }.padding(10)
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        settingsVisible.toggle()
                                    }
                                }) {
                                    Image(systemName: "person.fill")
                                }.padding(10)
                                Spacer()
                            }
                            .font(.headline)
                            .foregroundColor(Color.black)
                        }
                        Settings(visible: $settingsVisible)
                    } else {
                        Onboarding()
                    }
                } else {
                    Loading()
                }
            }
            .environmentObject(viewerModel)
        }
    }
}
