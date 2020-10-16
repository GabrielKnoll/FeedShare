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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
