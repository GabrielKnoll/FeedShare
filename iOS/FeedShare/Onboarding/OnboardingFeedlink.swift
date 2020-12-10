import Interface
import SwiftUI
import URLImage

public struct OnboardingFeedlink: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var finishDisabled = true

    public var body: some View {
        let client = viewerModel.viewerClient?.displayName ?? "your Podcast app"
        VStack {
            Text("To get Podcast recommendations from your friends right into \(client), subscribe to your personal feed:")
            FeedLink(text: viewerModel.viewer?.personalFeed ?? "")
            Button(action: {
                finishDisabled = false
            }) {
                Text("Subscribe in \(client)")
            }
            Button(action: {
                self.viewerModel.setupFinshed = true
            }) {
                Text("Finish Setup")
            }.disabled(finishDisabled)
        }
    }
}
