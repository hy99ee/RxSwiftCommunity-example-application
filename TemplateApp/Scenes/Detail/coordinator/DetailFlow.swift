import UIKit
import RxFlow

class DetailFlow {
    private let rootViewController: UIViewController
    private var viewController: DetailMainViewController!

    init(root rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    private func createViewController(openUser user: User) -> DetailMainViewController {
        let viewController = DetailMainViewController()
        let view = DetailMainView()
        let viewViewModel = DetailMainViewModel(user: user)
        view.viewModel = viewViewModel
        
        viewController.detailView = view.configured()
        
        let barViewController = TopBarViewController()
        let barView = TopBarView(type: .close)
        let barViewViewModel = TopBarViewModel()
        barView.viewModel = barViewViewModel
        
        barViewController.detailBarView = barView.configured()
        barViewController.closeStep = CreateStep.close
        
        viewController.barViewController = barViewController.configured()

        return viewController.configured()
    }
}

// MARK: - RxFlow
extension DetailFlow: Flow {
    var root: Presentable { rootViewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DetailtStep else { return navigateFromAppFlow(step) }

        switch step {
        case let .start(user):
            viewController = createViewController(openUser: user)

            viewController.modalPresentationStyle = .fullScreen
            rootViewController.present(viewController, animated: true)

            return .multiple(flowContributors: [
                .contribute(withNext: viewController),
                .contribute(withNext: viewController.barViewController)
            ])
            
        case .close:
            self.viewController.presentedViewController?.dismiss(animated: true)
            return .end(forwardToParentFlowWithStep: HomeStep.toCloseUser)
        }
    }
}
extension DetailFlow: ToAppFlowNavigation {}

private extension DetailFlow {
    func navigateToSomePlace() -> FlowContributors {
        return .none
    }
}


