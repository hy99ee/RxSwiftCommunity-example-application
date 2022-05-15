import UIKit
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let coordinator = FlowCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        openInitialScreen(windowScene: windowScene)
    }
}

extension SceneDelegate: ToAppFlowNavigation {
    private func openInitialScreen(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)

        coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.toRoot))

        Flows.use(appFlow, when: .created) { root in
            self.window?.setup(with: root)
        }
    }
}

