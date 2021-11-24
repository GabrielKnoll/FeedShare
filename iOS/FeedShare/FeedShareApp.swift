//
//  FeedShareApp.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import JGProgressHUD_SwiftUI
import OneSignal
import PartialSheet
import Shared
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    private var logoutObserver: NSObjectProtocol?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // OneSignal initialization
        if let appId = Bundle.main.object(forInfoDictionaryKey: "ONE_SIGNAL_APP_ID") as? String {
            OneSignal.initWithLaunchOptions(launchOptions)
            OneSignal.setAppId(appId)
        }
        logoutObserver = NotificationCenter.default.addObserver(forName: .logoutFeed, object: nil, queue: .main) { _ in
            OneSignal.removeExternalUserId()
        }
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

    let sheetManager = PartialSheetManager()

    init() {
        _isDark = State(initialValue: ViewerModel.shared.viewer == nil)
        UIAppearanceHelper.setup()
    }

    var body: some Scene {
        WindowGroup {
            if viewerModel.initialized {
                let binding = Binding(
                    get: { !viewerModel.setupFinshed || viewerModel.viewer == nil },
                    set: { _, _ in }
                )
                ZStack {
                    if viewerModel.setupFinshed, viewerModel.viewer != nil {
                        JGProgressHUDPresenter {
                            NavigationView {
                                Home()
                                    .navigationBarTitle("Home")
                                    .navigationBarHidden(true)
                            }
                            .addPartialSheet(
                                style: PartialSheetStyle(
                                    background: .solid(Color(UIColor.systemBackground)),
                                    accentColor: Color(R.color.secondaryColor.name),
                                    enableCover: true,
                                    coverColor: Color.black.opacity(0.4),
                                    cornerRadius: 38.5,
                                    minTopDistance: 50
                                )
                            )
                        }
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
                Image(R.image.logo.name)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .frame(height: 20)
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
