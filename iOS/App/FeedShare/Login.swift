import SwiftUI

public struct Login: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @ObservedObject var twitter = TwitterService()

    public var body: some View {
        VStack {
            Button(action: { self.twitter.authorize(viewerModel: self.viewerModel) }) {
                Text("Login with Twitter")
            }
            Text(twitter.credential?.userId ?? "")
            Text(twitter.credential?.screenName ?? "")
        }.onOpenURL { url in
            let callbackUrl = URL(string: "twittersdk://")
            let callbackScheme = callbackUrl?.scheme
            if url.scheme?.caseInsensitiveCompare(callbackScheme ?? "") != .orderedSame { return }
            let notification = Notification(name: .twitterCallback, object: url, userInfo: nil)
            NotificationCenter.default.post(notification)
        }.sheet(isPresented: self.$twitter.showSheet) {
            SafariView(url: self.$twitter.authUrl)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
