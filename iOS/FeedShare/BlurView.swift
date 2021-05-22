import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView

    let style: UIBlurEffect.Style

    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }

    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        if style == .extraLight, let vfxSubView = view.subviews.first(where: {
            String(describing: type(of: $0)) == "_UIVisualEffectSubview"
        }) {
            vfxSubView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
