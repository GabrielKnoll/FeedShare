//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import UIKit.UIGestureRecognizerSubclass

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}

class CopyableUIView: UIView {
    var copyText = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(SingleTouchDownGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    @objc func showMenu(sender: AnyObject?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: self.frame)
        }
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = copyText
        let menu = UIMenuController.shared
        menu.showMenu(from: self, rect: self.frame)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}

struct Copyable<Content: View>: UIViewRepresentable {
    let content: UIView
    let copyText: String
    
    @inlinable init(copyText: String, @ViewBuilder content: () -> Content) {
        self.copyText = copyText
        self.content = UIHostingController(rootView: content()).view
    }
    
    func makeUIView(context: Context) -> CopyableUIView {
        let view = CopyableUIView(frame: .zero)
        view.copyText = copyText
        content.frame = view.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        content.backgroundColor = .clear // unfortunate
        view.addSubview(content)
        
        return view
    }
    
    func updateUIView(_ uiView: CopyableUIView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var view: Copyable
        
        init(_ view: Copyable) {
            self.view = view
        }
    }
}

public struct FeedLink: View {
    let text: String
    
    public var body: some View {
        VStack(alignment: .leading) {
            Copyable(copyText: text) {
                Text(text)
                    .lineLimit(1)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }.padding(10)
        .frame(maxHeight: 60.0)
        .foregroundColor(.primary)
        .background(Color.primary.opacity(0.1))
        .cornerRadius(15)
    }
}
