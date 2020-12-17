//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
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
    var clientName: String?
    var openInClient: (() -> Void)?
    var completionHandler: (() -> Void)?
    
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
    
    @objc func openInApp() {
        if let open = self.openInClient {
            open()
        }
        
        if let ch = self.completionHandler {
            ch()
        }
    }
    
    @objc func showMenu(sender: AnyObject?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        
        if let name = clientName {
            let printToConsole = UIMenuItem(title: "Subscribe in \(name)", action: #selector(openInApp))
            menu.menuItems = [printToConsole]
        }
        
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: self.frame)
        }
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = copyText
        let menu = UIMenuController.shared
        menu.showMenu(from: self, rect: self.frame)
        if let ch = self.completionHandler {
            ch()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy) ||
            (clientName != nil && action == #selector(openInApp))
    }
}

struct Copyable<Content: View>: UIViewRepresentable {
    let content: UIView
    let copyText: String
    let clientName: String?
    let openInClient: () -> Void
    let completionHandler: (() -> Void)?
    
    @inlinable init(
        copyText: String,
        clientName: String? = nil,
        openInClient: @escaping () -> Void,
        completionHandler: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.copyText = copyText
        self.content = UIHostingController(rootView: content()).view
        self.clientName = clientName
        self.openInClient = openInClient
        self.completionHandler = completionHandler
    }
    
    func makeUIView(context: Context) -> CopyableUIView {
        let view = CopyableUIView(frame: .zero)
        view.openInClient = openInClient
        view.clientName = clientName
        view.copyText = copyText
        view.completionHandler = completionHandler
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
    @EnvironmentObject var viewerModel: ViewerModel
    let completionHandler: (() -> Void)?
    
    init(_ completionHandler: (() -> Void)? = nil) {
        self.completionHandler = completionHandler
    }
    
    public var body: some View {
        let text = viewerModel.viewer?.personalFeed ?? ""
        VStack(alignment: .leading) {
            Copyable(
                copyText: text,
                clientName: viewerModel.viewerClient?.displayName,
                openInClient: {
                    SubscribeButton.openURL(
                        viewerModel.viewerClient!,
                        feed: viewerModel.viewer?.personalFeed
                    )
                },
                completionHandler: completionHandler
            ) {
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
