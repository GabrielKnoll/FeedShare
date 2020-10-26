//
//  CustomShareViewController.swift
//  FeedShareExtension
//
//  Created by Gabriel Knoll on 16.10.20.
//

import Interface
import SwiftUI
import UIKit

class CustomShareViewController: UIViewController {

	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = Interface.R.color.background()
		addNavItems()
		addHostingController()
		view.backgroundColor = R.color.background()
	}

	private func addNavItems() {
		navigationItem.title = "FeedShare"

		let cancelBarButton = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self, action: #selector(cancelAction))
		navigationItem.setLeftBarButton(cancelBarButton, animated: false)

		let sendBarButton = UIBarButtonItem(title: "Teilen", style: .done, target: self, action: #selector(sendAction))
		navigationItem.setRightBarButton(sendBarButton, animated: false)

	}

	private func addHostingController() {
		let controller = UIHostingController(rootView: PostView())
		addChild(controller)
		view.addSubview(controller.view)
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.height ?? 0) + 20),
			controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
			controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
		])
		controller.view.backgroundColor = .clear
		controller.didMove(toParent: self)
	}

	@objc private func cancelAction() {
		extensionContext?.cancelRequest(withError: NSError(domain: "com.feedshare.Feedshare", code: 0, userInfo: nil))
	}

	@objc private func sendAction() {
		extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
	}
}
