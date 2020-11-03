import Logic
import NetworkManager
import SwiftUI

public struct Login: View {
    @ObservedObject var viewerModel: ViewerModel
    @ObservedObject var twitter: TwitterService

    public init(viewerModel: ViewerModel) {
        self.viewerModel = viewerModel
        self.twitter = TwitterService(viewerModel: viewerModel)
    }
    
    public var body: some View {
        VStack {
            Button(action: { self.twitter.authorize() }) {
                Text("Login with Twitter")
            }
            Text(twitter.credential?.userId ?? "")
            Text(twitter.credential?.screenName ?? "")
        }.onOpenURL { url in
            print("Open URL: \(url)")
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
        Login(viewerModel: ViewerModel(networkManager: NetworkManager.success))
    }
}
