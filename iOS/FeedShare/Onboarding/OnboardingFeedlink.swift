import Shared
import SwiftUI
import URLImage

public struct OnboardingFeedlink: View {
    var onNext: () -> Void

    public var body: some View {
        VStack {
            Spacer()
            OnboardingTextPairing(
                title: "Personal Feed",
                subtitle: "Subscribe from your podcast app to listen to recommendations from the people you follow.",
                dark: false
            )
            FeedLink().padding(.top, 24)
            Text("Copy the link above into your podcast app to subscribe.")
                .padding(.top, 6)
                .padding(.horizontal, 15)
                .foregroundColor(Color(R.color.secondaryColor.name))
                .font(Typography.body)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: onNext) {
                Text("Done")
            }
            .buttonStyle(FilledButton())
            .padding(.bottom, 44)
        }
    }
}
