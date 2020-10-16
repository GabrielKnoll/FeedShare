//
//  CustomShareViewController.swift
//  FeedShareExtension
//
//  Created by Gabriel Knoll on 16.10.20.
//

import UIKit

class CustomShareViewController: UIViewController {
	@IBOutlet weak var helloLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .lightGray
		helloLabel.text = "Hello World"
		addNavItems()
    }

	private func addNavItems() {
		navigationItem.title = "FeedShare"

		let cancelBarButton = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self, action: #selector(cancelAction))
		navigationItem.setLeftBarButton(cancelBarButton, animated: false)

		let sendBarButton = UIBarButtonItem(title: "Teilen", style: .done, target: self, action: #selector(sendAction))
		navigationItem.setRightBarButton(sendBarButton, animated: false)

	}

	@objc private func cancelAction() {
		extensionContext?.cancelRequest(withError: NSError(domain: "com.feedshare.Feedshare", code: 0, userInfo: nil))
	}

	@objc private func sendAction() {
		extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
	}
}
