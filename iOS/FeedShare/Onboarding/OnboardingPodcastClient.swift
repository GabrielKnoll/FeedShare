import Shared
import SwiftUI

public struct OnboardingPodcastClient: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State var showingAlert = false
    @State var clientName: String?

    var onNext: () -> Void

    public var body: some View {
        VStack {
            Spacer()
            OnboardingTextPairing(
                title: "Listen to your recommendations",
                subtitle: "Subscribe to episodes shared by the people you follow right in your podcast app.",
                dark: false
            )
            VStack(spacing: 0) {
                ForEach(viewerModel.podcastClients, id: \.id) { client in
                    PodcastClientRow(icon: client.icon, name: client.displayName) {
                        SubscribeButton.openURL(client, feed: viewerModel.viewer?.personalFeedUrl) { success in
                            if success {
                                viewerModel.viewerClient = client
                                onNext()
                            } else {
                                clientName = client.displayName
                                showingAlert = true
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            Spacer()
            Button(action: {
                viewerModel.viewerClient = nil
                onNext()
            }) {
                Text("I’m using a different app")
            }
            .buttonStyle(LinkButton())
        }
        .onAppear(perform: viewerModel.fetchPodcastClients)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Could not open \(clientName ?? "Podcast App")"),
                message: Text("The app might not be installed. You can manually subscribe to your Personal Feed by copying the link."),
                dismissButton: .default(Text("OK")
                ) {
                    viewerModel.viewerClient = nil
                    onNext()
                }
            )
        }
    }
}
