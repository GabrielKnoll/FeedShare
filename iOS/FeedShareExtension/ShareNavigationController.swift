//
//  ShareNavigationController.swift
//  FeedShareExtension
//
//  Created by Gabriel Knoll on 16.10.20.
//

import Combine
import Shared
import SwiftUI
import UIKit

@objc(ShareNavigationController)
class ShareNavigationController: UIViewController {
    var initializer: AnyCancellable?
    var isReady: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        UIAppearanceHelper.setup()
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        
        var hasFound = false
        
        initializer = ViewerModel.shared.$initialized.sink(receiveValue: { isReady in
            if isReady, !self.isReady {
                for extensionItem in extensionItems {
                    if let itemProviders = extensionItem.attachments {
                        for itemProvider in itemProviders {
                            if !hasFound, itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                                hasFound = true
                                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { url, _ in
                                    DispatchQueue.main.async {
                                        if let shareURL = url as? URL {
                                            let controller = UIHostingController(rootView: Composer(dismiss: { success in
                                                if success {
                                                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                                } else {
                                                    self.extensionContext?.cancelRequest(withError: NSError(
                                                        domain: "com.findtruffle.extension",
                                                        code: 0,
                                                        userInfo: nil
                                                    ))
                                                }

                                            }, url: shareURL.absoluteString).environmentObject(ViewerModel.shared))
                                            self.addChild(controller)

                                            self.view.addSubview(controller.view)
                                            controller.view.translatesAutoresizingMaskIntoConstraints = false
                                            NSLayoutConstraint.activate([
                                                controller.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                                                controller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
                                                controller.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                                controller.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                            ])
                                        }
                                    }
                                }
                            }
                            if hasFound { break }
                        }
                    }
                    if hasFound { break }
                }
            }
        })
    }
}
