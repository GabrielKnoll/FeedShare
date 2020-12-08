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
    @ObservedObject private var overlayModel = OverlayModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if viewerModel.initialized {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        FeedStream(showComposer: {
                            overlayModel.active = .composer
                        })
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "house.fill")
                                }.padding(10)
                                Spacer()
                                Button(action: {
                                    overlayModel.active = .settings
                                }) {
                                    Image(systemName: "person.fill")
                                }.padding(10)
                                Spacer()
                            }
                            .font(.headline)
                            .foregroundColor(Color.black)
                            
                        }.ignoresSafeArea(.keyboard, edges: .bottom)
                        Settings()
                        Composer()
                    } else {
                        Onboarding()
                    }
                } else {
                    Loading()
                }
            }
            .environmentObject(viewerModel)
            .environmentObject(overlayModel)
        }
    }
}
