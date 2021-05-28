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
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent) {
        if state == .possible {
            state = .recognized
        }
    }

    override func touchesMoved(_: Set<UITouch>, with _: UIEvent) {
        state = .failed
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent) {
        state = .failed
    }
}

class CopyableUIView: UIView {
    var copyText = ""
    var clientName: String?
    var openInClient: (() -> Void)?
    var completionHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(SingleTouchDownGestureRecognizer(target: self, action: #selector(showMenu)))
    }

    @objc func openInApp() {
        if let open = openInClient {
            open()
        }

        if let ch = completionHandler {
            ch()
        }
    }

    @objc func showMenu(sender _: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared

        if let name = clientName {
            let printToConsole = UIMenuItem(title: "Subscribe in \(name)", action: #selector(openInApp))
            menu.menuItems = [printToConsole]
        }

        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: frame)
        }
    }

    override func copy(_: Any?) {
        UIPasteboard.general.string = copyText
        let menu = UIMenuController.shared
        menu.showMenu(from: self, rect: frame)
        if let ch = completionHandler {
            ch()
        }
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        action == #selector(UIResponderStandardEditActions.copy) ||
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

    func makeUIView(context _: Context) -> CopyableUIView {
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

    func updateUIView(_: CopyableUIView, context _: Context) {}

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
    @State var isCopied: Bool = false

    public var body: some View {
        let text = viewerModel.viewer?.personalFeedUrl ?? ""

        Button(action: {
            UIPasteboard.general.string = text
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isCopied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isCopied = false
            }
        }) {
            ZStack {
                if isCopied {
                    HStack(alignment: .center) {
                        Text("Copied to Clipboard")
                            .lineLimit(1)
                            .foregroundColor(Color(R.color.primaryColor.name))
                            .font(Typography.caption)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(R.color.brandColor.name))
                            .frame(maxHeight: 20)
                    }
                    .frame(height: 50)
                    .transition(.move(edge: .bottom))
                } else {
                    HStack(alignment: .center) {
                        Text(text)
                            .lineLimit(1)
                            .foregroundColor(Color(R.color.primaryColor.name))
                            .font(Typography.bodyMedium)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "doc.on.doc.fill")
                            .foregroundColor(Color(R.color.primaryColor.name))
                            .frame(maxHeight: 20)
                    }
                    .frame(height: 50)
                    .transition(.move(edge: .bottom))
                }
            }
            .frame(maxHeight: 50)
            .padding(.horizontal, 12)
            .animation(.easeOut(duration: 0.2))
        }
        .buttonStyle(InputButton())
    }

    //            Copyable(
    //                copyText: text,
    //                clientName: viewerModel.viewerClient?.displayName,
    //                openInClient: {
    //                    SubscribeButton.openURL(
    //                        viewerModel.viewerClient!,
    //                        feed: viewerModel.viewer?.personalFeed
    //                    )
    //                },
    //                completionHandler: completionHandler
    //            ) {
    //                Text(text)
    //                    .lineLimit(1)
    //                    .font(Typography.body)
    //                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    //            }
}
