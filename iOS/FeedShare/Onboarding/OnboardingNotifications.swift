import OneSignal
import Shared
import SwiftUI

public struct OnboardingNotifications: View {
    @EnvironmentObject var viewerModel: ViewerModel
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Friends()
            Text("Get notified when one of your friends shares a recommendation.")
            Button(action: {
                OneSignal.promptForPushNotifications(userResponse: { accepted in
                    print("User accepted notifications: \(accepted)")
                    onNext()
                })
            }) {
                Text("Turn on Notifications")
            }.buttonStyle(FilledButton())
            Button(action: {
                onNext()
            }) {
                Text("Skip")
            }.buttonStyle(SecondaryButton())
        }
    }
}
