import SwiftUI

public struct OnboardingPodcastClient: View {
    @StateObject var model = OnboardingPodcastClientModel()
    @EnvironmentObject var viewerModel: ViewerModel
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Text("Which Podcast client are you using?")
            ForEach(model.podcastClients, id: \.id) { client in
                Button(action: {
                    viewerModel.viewerClient = client
                    onNext()
                }) {
                    PodcastClientRow(client: client)
                }
            }
        }
    }
}
