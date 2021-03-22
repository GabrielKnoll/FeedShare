import Shared
import SwiftUI

public struct OnboardingLogin: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @StateObject var twitter = TwitterService()
    @State var buttonDisabled = false

    var onNext: () -> Void

    public var body: some View {
        VStack {
            Spacer()
            OnboardingTextPairing(
                title: "Podcast Recommendations",
                subtitle: "Share episodes you like with your followers and discover new podcasts.",
                dark: true
            )
            Spacer()
            Button(action: {
                if buttonDisabled { return }
                buttonDisabled = true
                self.twitter.authorize(viewerModel: self.viewerModel)
            }) {
                if buttonDisabled {
                    ActivityIndicator(style: .white).colorScheme(.dark)
                } else {
                    HStack(alignment: .center) {
                        Image(R.image.twitter.name)
                        Text("Login with Twitter")
                    }
                }
            }
            .disabled(buttonDisabled)
            .buttonStyle(FilledButton())
            .padding(.bottom, 44)
        }.onOpenURL { url in
            let callbackUrl = URL(string: "twittersdk://")
            let callbackScheme = callbackUrl?.scheme
            if url.scheme?.caseInsensitiveCompare(callbackScheme ?? "") != .orderedSame { return }
            let notification = Notification(name: .twitterCallback, object: url, userInfo: nil)
            NotificationCenter.default.post(notification)
        }.sheet(isPresented: self.$twitter.showSheet) {
            SafariView(url: self.$twitter.authUrl)
        }.onReceive(viewerModel.$viewer, perform: { viewer in
            if viewer != nil {
                onNext()
            } else {
                buttonDisabled = false
            }
        })
    }
}
