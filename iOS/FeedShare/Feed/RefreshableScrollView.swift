// Authoer: The SwiftUI Lab
// Full article: https://swiftui-lab.com/scrollview-pull-to-refresh/
import SwiftUI

enum PTRState {
    case nothing
    case triggered
    case waitingForRelease
}

struct RefreshableScrollView<Content: View>: View {
    @Binding var refreshing: Bool
    @State private var previousScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var frozen: Bool = false {
        didSet {
            showHideLoadingView()
        }
    }
    @State private var rotation: Angle = .degrees(0)
    @State private var state: PTRState = .nothing
    @State private var spacerVisible: Bool = false

    var threshold: CGFloat = 80
    
    let paddingTop: CGFloat
    let content: Content

    init(height: CGFloat = 80, refreshing: Binding<Bool>, paddingTop: CGFloat = 0, @ViewBuilder content: () -> Content) {
        threshold = height
        self.paddingTop = paddingTop
        _refreshing = refreshing
        self.content = content()
    }
    
    func showHideLoadingView() {
        if refreshing, frozen {
            spacerVisible = true
        } else if spacerVisible {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation {
                spacerVisible = false
            }
        }
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    MovingView()
                    VStack {
                        if spacerVisible {
                            Color.clear.frame(height: threshold)
                        }
                        self.content
                    }
                    SymbolView(height: self.threshold, loading: self.refreshing, frozen: self.frozen, rotation: self.rotation)
                }.padding(.top, paddingTop)
            }
            .background(FixedView())
            .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
                self.refreshLogic(values: values)
            }.onChange(of: refreshing, perform: { _ in
                showHideLoadingView()
            })
        }
    }

    func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero

            self.scrollOffset = movingBounds.minY - fixedBounds.minY - paddingTop
            
            self.rotation = self.symbolRotation(self.scrollOffset)

            // Crossing the threshold on the way down, we start the refresh process
            if !self.refreshing, self.scrollOffset > self.threshold, self.previousScrollOffset <= self.threshold, self.state == .nothing {
                self.state = .triggered
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else if self.state == .triggered, self.scrollOffset < self.previousScrollOffset {
                self.state = .waitingForRelease
                self.refreshing = true
            }
            
            if self.scrollOffset == 0 {
                // reset state
                self.state = .nothing
            }

            if self.refreshing {
                // Crossing the threshold on the way up, we add a space at the top of the scrollview
                if self.previousScrollOffset > self.threshold, self.scrollOffset <= self.threshold {
                    self.frozen = true
                }
            } else {
                // remove the sapce at the top of the scroll view
                self.frozen = false
            }

            // Update last scroll offset
            self.previousScrollOffset = self.scrollOffset
        }
    }

    func symbolRotation(_ scrollOffset: CGFloat) -> Angle {
        // We will begin rotation, only after we have passed
        // 60% of the way of reaching the threshold.
        if scrollOffset < threshold * 0.60 {
            return .degrees(0)
        } else {
            // Calculate rotation, based on the amount of scroll offset
            let h = Double(threshold)
            let d = Double(scrollOffset)
            let v = max(min(d - (h * 0.6), h * 0.4), 0)
            return .degrees(180 * v / (h * 0.4))
        }
    }

    struct SymbolView: View {
        var height: CGFloat
        var loading: Bool
        var frozen: Bool
        var rotation: Angle

        var body: some View {
            Group {
                if self.loading { // If loading, show the activity control
                    VStack {
                        Spacer()
                        ActivityRep()
                        Spacer()
                    }.frame(height: height).fixedSize()
                        .offset(y: -height + (self.loading && self.frozen ? height : 0.0))
                } else {
                    Image(systemName: "arrow.down") // If not loading, show the arrow
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: height * 0.25, height: height * 0.25).fixedSize()
                        .padding(height * 0.375)
                        .rotationEffect(rotation)
                        .offset(y: -height + (loading && frozen ? +height : 0.0))
                }
            }
        }
    }

    struct MovingView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self,
                                       value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
            }.frame(height: 0)
        }
    }

    struct FixedView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self,
                                       value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
            }
        }
    }
}

enum RefreshableKeyTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }

    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        // swiftlint:disable:next nesting
        typealias Value = [PrefData]
    }
}

struct ActivityRep: UIViewRepresentable {
    func makeUIView(context _: UIViewRepresentableContext<ActivityRep>) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityRep>) {
        uiView.startAnimating()
    }
}
