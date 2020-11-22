import SwiftUI

public struct OnboardingPodcastClient: View {
    @StateObject var model = OnboardingPodcastClientModel()

    public var body: some View {
        VStack {
            Text("Which Podcast client are you using?")
            List(model.podcastClients, id: \.id) { client in
                Button(action: {}) {
                    Text(client.displayName)
                }
            }
        }
    }
}
