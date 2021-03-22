import Shared
import SwiftUI

public struct Onboarding: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var currentPage: Int
    @Binding var isDark: Bool

    public init(_ isDark: Binding<Bool>) {
        _isDark = isDark
        _currentPage = State(initialValue: ViewerModel.shared.viewer == nil ? 0 : 1)
    }

    func next(_ page: Int) {
        if page < currentPage {
            return
        }
        if currentPage == 2, viewerModel.viewerClient != nil {
            finishSetup()
        } else {
            withAnimation(Animation.linear(duration: 0.2)) {
                currentPage = page
                isDark = currentPage == 0
            }
        }
    }

    func finishSetup() {
        viewerModel.setupFinshed = true
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color(isDark ? R.color.primaryColor.name : R.color.backgroundColor.name))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.linear)

                VStack(alignment: .leading) {
                    Image(R.image.logo.name)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color(isDark ? R.color.backgroundColor.name : R.color.primaryColor.name))
                        .frame(maxWidth: 90)
                        .padding(.horizontal, 25)
                        .padding(.top, 10)
                        .animation(.linear)

                    TabView(selection: $currentPage) {
                        OnboardingLogin(onNext: { next(1) }).padding(.horizontal, 25).tag(0)
                        OnboardingNotifications(onNext: { next(2) }).padding(.horizontal, 25).tag(1)
                        OnboardingPodcastClient(onNext: { next(3) }).padding(.horizontal, 25).tag(2)
                        OnboardingFeedlink(onNext: finishSetup).padding(.horizontal, 25).tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onAppear(perform: {
                        UIScrollView.appearance().isScrollEnabled = false
                    })
                }

                .padding(.top, geo.safeAreaInsets.top)
                .padding(.bottom, geo.safeAreaInsets.bottom)
            }
            .colorScheme(.light)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
