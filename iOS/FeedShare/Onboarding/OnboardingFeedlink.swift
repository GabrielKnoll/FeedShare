import Shared
import SwiftUI
import URLImage

public struct OnboardingFeedlink: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var subscribed = false

    public var body: some View {
        let client = viewerModel.viewerClient?.displayName ?? "your Podcast app"
        VStack {
            Text("To get Podcast recommendations from your friends right into \(client), subscribe to your personal feed:")
            FeedLink {
                subscribed = true
            }
            SubscribeButton(feed: viewerModel.viewer?.personalFeed) { _ in
                subscribed = true
            }.buttonStyle(FilledButton())
            Button(action: {
                self.viewerModel.setupFinshed = true
            }) {
                Text("Finish Setup")
            }.disabled(!subscribed && (viewerModel.viewerClient != nil))
        }
    }
}
