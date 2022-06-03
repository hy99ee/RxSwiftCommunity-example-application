import UIKit

extension UIWindow {
    func setup(with rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.makeKeyAndVisible()
    }
}

extension UINavigationItem {
    internal func setAppearance(_ appearance: UINavigationBarAppearance) {
        self.standardAppearance = appearance
        self.compactAppearance = appearance
        self.scrollEdgeAppearance = appearance

        if #available(iOS 15.0, *) {
            self.compactScrollEdgeAppearance = appearance
        }
    }
}
