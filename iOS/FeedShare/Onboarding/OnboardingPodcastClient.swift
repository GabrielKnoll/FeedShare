import SwiftUI

public struct OnboardingPodcastClient: View {
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Text("Which Podcast client are you using?")
            PodcastClients(onSelect: onNext)
        }
    }
}
