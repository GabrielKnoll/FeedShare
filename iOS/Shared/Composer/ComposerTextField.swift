import SwiftUI
import UIKit

struct ComposerTextField: UIViewRepresentable {
    @Binding var text: String
    let limit: Int
    let disabled: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator($text, limit: limit, disabled: disabled)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = R.font.interMedium(size: 16)
        textView.textColor = R.color.primaryColor()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.becomeFirstResponder()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        context.coordinator.disabled = disabled
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let text: Binding<String>
        let limit: Int
        var disabled: Bool

        init(_ text: Binding<String>, limit: Int, disabled: Bool) {
            self.text = text
            self.limit = limit
            self.disabled = disabled
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return !disabled && newText.count <= limit
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
        }
    }
}
