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
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.becomeFirstResponder()
        print("asd")
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        context.coordinator.disabled = self.disabled
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
            return !disabled && newText.count <= self.limit
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("bsd")
            self.text.wrappedValue = textView.text
        }
    }
}
