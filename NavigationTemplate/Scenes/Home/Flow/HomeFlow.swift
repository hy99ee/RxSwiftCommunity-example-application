import UIKit
import RxFlow

class HomeFlow {
    var rootViewController: UINavigationController
    private let viewController: HomeViewController

    init(root rootViewController: UINavigationController) {
        self.rootViewController = rootViewController

        viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel
    }
}

// MARK: - RxFlow
extension HomeFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return navigateFromAppFlow(step) }

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))

        case .toAbout:
            return navigateToAbout()
            
        case .toSettings:
            return navigateFromAppFlow(AppStep.toSettings)
            
        case .toCreate:
            return navigateFromAppFlow(AppStep.toCreate)
        }
    }
}
extension HomeFlow: ToAppFlowNavigation {}

private extension HomeFlow {
    func navigateToAbout() -> FlowContributors {
        let viewController = HomeAboutViewController()
        let viewModel = HomeAboutViewModel()
        viewController.viewModel = viewModel

        rootViewController.present(viewController, animated: true)

        return .none
    }
}


