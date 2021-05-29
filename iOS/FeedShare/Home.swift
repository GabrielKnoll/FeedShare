//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import JGProgressHUD_SwiftUI
import PartialSheet
import Shared
import SwiftUI

public struct Home: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @State private var composerVisible = false
    @State private var activeFeedType = 0

    public init() {}

    public var body: some View {
        JGProgressHUDPresenter {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    VStack {
                        let paddingTop = geo.safeAreaInsets.top + 57
                        TabView(selection: $activeFeedType) {
                            Feed(type: .Personal, paddingTop: paddingTop).tag(0)
                            Feed(type: .Global, paddingTop: paddingTop).tag(1)
                        }
                        .animation(.default, value: activeFeedType)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onAppear(perform: {
                            UIScrollView.appearance().isScrollEnabled = false
                        })
                    }

                    VStack {
                        ZStack {
                            Image(R.image.logo.name)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(R.color.primaryColor.name))
                                .frame(height: 20)

                            HStack {
                                if let userId = viewerModel.viewer?.user.id {
                                    NavigationLink(destination: Profile(userId: userId)) {
                                        ProfilePicture(url: viewerModel.viewer?.user.profilePicture, size: 28)
                                            .padding(7)
                                    }
                                }

                                Spacer()

                                Button(action: {
                                    composerVisible = true
                                }) {
                                    Image(R.image.composer.name)
                                        .renderingMode(.template)
                                        .foregroundColor(Color(R.color.primaryColor.name))
                                        .padding(7)
                                }.foregroundColor(Color.primary)
                                
                            }
                            .padding(.horizontal, 15)
                        }

                        SlidingTabView(
                            selection: $activeFeedType,
                            tabs: [
                                "Personal",
                                "Global",
                            ],
                            font: Typography.caption,
                            activeAccentColor: Color(R.color.primaryColor.name),
                            inactiveAccentColor: Color(R.color.secondaryColor.name),
                            selectionBarColor: Color(R.color.primaryColor.name)
                        )
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                    .background(BlurView(style: .extraLight))
                    .edgesIgnoringSafeArea(.top)
                }
                .edgesIgnoringSafeArea(.bottom)
                .onReceive(viewerModel.feedNotSubscribed) { _ in
                    partialSheetManager.showPartialSheet({
                        //
                    }) {
                        FeedSubscribe()
                    }
                }
                .sheet(isPresented: $composerVisible) {
                    Composer(dismiss: { _ in composerVisible = false })
                        .environmentObject(viewerModel)
                }
            }
        }
    }
}
