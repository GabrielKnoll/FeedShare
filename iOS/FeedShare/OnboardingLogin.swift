import SwiftUI

public struct OnboardingLogin: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @ObservedObject var twitter = TwitterService()
    @State var buttonDisabled = false
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Text("FeedShare allows you to recommend podcast episodes to your friends and listen to their recommendations")
            Button(action: {
                buttonDisabled = true
                self.twitter.authorize(viewerModel: self.viewerModel)
            }) {
                Text("Login with Twitter")
            }
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
            }
        })
    }
}
