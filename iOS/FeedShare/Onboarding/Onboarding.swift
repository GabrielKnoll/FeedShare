import Shared
import SwiftUI

public struct Onboarding: View {
    @State private var currentPage = 0

	public init() {}

    func next() {
        if currentPage < 3 {
            withAnimation {
                currentPage += 1
            }
        }
    }

    public var body: some View {
        VStack {
            Image(R.image.logo.name)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.red)
                .frame(maxWidth: 80)
            
            TabView(selection: $currentPage) {
                OnboardingLogin(onNext: next).tag(0)
                OnboardingNotifications(onNext: next).tag(1)
                OnboardingPodcastClient(onNext: next).tag(2)
                OnboardingFeedlink().tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear(perform: {
                UIScrollView.appearance().isScrollEnabled = false
            })
        }
        .background(Color.white)
    }
}
