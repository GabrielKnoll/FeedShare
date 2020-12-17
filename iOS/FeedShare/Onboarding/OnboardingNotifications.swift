import Shared
import SwiftUI

public struct OnboardingNotifications: View {
    @EnvironmentObject var viewerModel: ViewerModel
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Text("Get notified when one of your friends shares a recommendation.")
            Button(action: {}) {
                Text("Turn on Notifications")
            }
            Button(action: {
                onNext()
            }) {
                Text("Skip")
            }
        }
    }
}
