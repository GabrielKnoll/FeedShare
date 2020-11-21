//
//  ShareNavigationController.swift
//  FeedShareExtension
//
//  Created by Gabriel Knoll on 16.10.20.
//

import UIKit

@objc(ShareNavigationController)
class ShareNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([CustomShareViewController()], animated: false)
    }
}
