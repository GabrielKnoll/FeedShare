import SafariServices
import SwiftUI

final class CustomSafariViewController: UIViewController {
    var url: URL? {
        didSet {
            configure() // when url changes, reset the safari child view controller
        }
    }

    private var safariViewController: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        // Remove the previous safari child view controller if not nil
        if let safariViewController = safariViewController {
            safariViewController.willMove(toParent: self)
            safariViewController.view.removeFromSuperview()
            safariViewController.removeFromParent()
            self.safariViewController = nil
        }
        guard let url = url else { return }
        // Create a new safari child view controller with the url
        let newSafariViewController = SFSafariViewController(url: url)
        addChild(newSafariViewController)
        newSafariViewController.view.frame = view.frame
        view.addSubview(newSafariViewController.view)
        newSafariViewController.didMove(toParent: self)
        safariViewController = newSafariViewController
    }
}

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomSafariViewController

    @Binding var url: URL?

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> CustomSafariViewController {
        CustomSafariViewController()
    }

    func updateUIViewController(_ safariViewController: CustomSafariViewController,
                                context _: UIViewControllerRepresentableContext<SafariView>)
    {
        safariViewController.url = url // updates our VC's underlying properties
    }
}
