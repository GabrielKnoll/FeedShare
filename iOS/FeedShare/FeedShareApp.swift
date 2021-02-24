//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import OneSignal
import PartialSheet
import Shared
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("5f5335b9-b7e0-4cfa-9123-81fb6329113c")
        
        return true
    }
}

@main
struct FeedShareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var viewerModel = ViewerModel.shared
    @State var isDark: Bool {
        didSet {
            UIApplication.shared.windows.first?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    let sheetManager: PartialSheetManager = PartialSheetManager()
    
    init() {
        _isDark = State(initialValue: ViewerModel.shared.viewer == nil)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: R.font.interBold(size: 35),
            .foregroundColor: R.color.primaryColor()
        ]
        
        UINavigationBar.appearance().tintColor = R.color.primaryColor()!
        UINavigationBar.appearance().barTintColor = UIColor.systemBackground
        UINavigationBar.appearance().shadowImage = nil
        UINavigationBar.appearance().setBottomBorderColor(color: UIColor.red, height: 1)
        // UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font: R.font.interSemiBold(size: 17),
            .foregroundColor: R.color.primaryColor()
        ]
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = R.color.primaryColor()
        
    }
    
    var body: some Scene {
        WindowGroup {
            if viewerModel.initialized {
                let binding = Binding(
                    get: { return !viewerModel.setupFinshed || viewerModel.viewer == nil },
                    set: { _, _ in }
                )
                ZStack {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        NavigationView {
                            Home()
                                .navigationBarTitle("Home")
                                .navigationBarHidden(true)
                        }
                        .addPartialSheet(style: PartialSheetStyle(
                                            background: .solid(Color(UIColor.systemBackground)),
                                            handlerBarColor: Color(R.color.secondaryColor.name),
                                            enableCover: true,
                                            coverColor: Color.black.opacity(0.4),
                                            cornerRadius: 38.5,
                                            minTopDistance: 50)
                        )
                        
                    }
                }
                .preferredColorScheme(isDark ? .dark : .light)
                .fullScreenCover(isPresented: binding) {
                    Onboarding($isDark)
                        .environmentObject(viewerModel) // add environmentObject again, because it's a separate view stack
                }
                .environmentObject(viewerModel)
                .environmentObject(sheetManager)
                .onReceive(viewerModel.$viewer, perform: { viewer in
                    isDark = viewer == nil
                 
                    if let id = viewer?.user.id.components(separatedBy: ":").last {
                        OneSignal.setExternalUserId(id)
                    }
                })
            } else {
                Loading()
            }
        }
    }
}

extension UINavigationBar {
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
