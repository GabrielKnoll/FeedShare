import OneSignal
import Shared
import SwiftUI

public struct OnboardingNotifications: View {
    @EnvironmentObject var viewerModel: ViewerModel
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Spacer()
            OnboardingTextPairing(
                title: "Get Notfied",
                subtitle: "We’ll let you know when someone you follow recommends an episode.",
                dark: false
            )
            Spacer()
            Facepile().padding(.bottom, 24)
            Button(action: {
                OneSignal.promptForPushNotifications(userResponse: { accepted in
                    print("User accepted notifications: \(accepted)")
                    onNext()
                })
            }) {
                Text("Turn on Notifications")
            }
            .buttonStyle(FilledButton())
            Button(action: onNext) {
                Text("Skip")
            }
            .buttonStyle(LinkButton())
        }
    }
}
