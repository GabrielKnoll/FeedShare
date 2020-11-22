import SwiftUI

public struct Onboarding: View {
    @State private var currentPage = 0

    func next() {
        withAnimation {
            currentPage += 1
        }
    }

    public var body: some View {
        VStack {
            Text("truffle \(currentPage)").font(.system(size: 26, weight: .bold, design: .rounded))
            TabView(selection: $currentPage) {
                OnboardingLogin(onNext: next).tag(0)
                OnboardingNotifications(onNext: next).tag(1)
                OnboardingPodcastClient().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear(perform: {
                UIScrollView.appearance().isScrollEnabled = false
            })
        }
    }
}
