import Shared
import SwiftUI

public struct OnboardingTextPairing: View {
    let title: String
    let subtitle: String
    let dark: Bool

    public var body: some View {
        VStack(alignment: .leading) {
            RepresentedUILabelView(
                attributedText: title,
                color: dark ? R.color.backgroundColor() : R.color.primaryColor(),
                font: R.font.interBold(size: 35),
                width: UIScreen.main.bounds.size.width - 50
            ).fixedSize()
            Rectangle()
                .fill(Color(R.color.dangerColor.name))
                .frame(width: 50, height: 3)
                .padding(.top, -0.5)
                .padding(.bottom, 4)
            Text(subtitle)
                .font(Typography.title3)
                .foregroundColor(Color(R.color.secondaryColor.name))
        }
    }
}

struct RepresentedUILabelView: UIViewRepresentable {
    typealias UIViewType = UILabel

    let attributedText: String
    let color: UIColor?
    let font: UIFont?
    let width: CGFloat

    func makeUIView(context _: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = color
        label.font = font
        label.preferredMaxLayoutWidth = width

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -20
        paragraphStyle.maximumLineHeight = 35
        paragraphStyle.hyphenationFactor = 0.1

        let attrString = NSMutableAttributedString(string: attributedText)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))

        label.clipsToBounds = true
        label.attributedText = attrString

        return label
    }

    func updateUIView(_: UILabel, context _: Context) {}
}
