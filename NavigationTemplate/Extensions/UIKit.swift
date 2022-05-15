import UIKit

extension UIWindow {
    func setup(with rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.makeKeyAndVisible()
    }
}
