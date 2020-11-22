import SwiftUI

public struct OnboardingLogin: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @ObservedObject var twitter = TwitterService()
    var onNext: () -> Void
    
    public var body: some View {
        VStack {
            Text("FeedShare allows you to recommend podcast episodes to your friends and listen to their recommendations")
            Button(action: { self.twitter.authorize(viewerModel: self.viewerModel) }) {
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
        }.onReceive(viewerModel.objectWillChange, perform: { vm in
            if vm.viewer != nil {
                onNext()
            }
        })
    }
}
