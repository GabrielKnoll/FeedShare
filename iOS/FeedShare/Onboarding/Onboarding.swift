import Shared
import SwiftUI

public struct Onboarding: View {
    @State private var currentPage = 0

	public init() {}

    func next(_ page: Int) {
        if currentPage < 3 {
            withAnimation {
                currentPage = page
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
                OnboardingLogin(onNext: { next(1) }).tag(0)
                OnboardingNotifications(onNext: { next(2) }).tag(1)
                OnboardingPodcastClient(onNext: { next(3) }).tag(2)
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
