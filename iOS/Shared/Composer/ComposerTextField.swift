import SwiftUI
import UIKit

struct ComposerTextField: UIViewRepresentable {
    @Binding var text: String
    let limit: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text, limit: limit)
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
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let text: Binding<String>
        let limit: Int

        init(_ text: Binding<String>, limit: Int) {
            self.text = text
            self.limit = limit
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= self.limit
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}
