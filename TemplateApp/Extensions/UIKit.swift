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

extension UIView {
    func appendTo(_ array: inout [UIView]) -> Self {
        array.append(self)

        return self
    }
}
