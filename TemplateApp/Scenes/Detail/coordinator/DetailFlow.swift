import UIKit
import RxFlow

class DetailFlow {
    private let rootViewController: UIViewController
    let viewController = DetailMainViewController()

    init(root rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - RxFlow
extension DetailFlow: Flow {
    var root: Presentable { rootViewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DetailtStep else { return navigateFromAppFlow(step) }

        switch step {
        case let .start(user):

            let view = DetailMainView()
            let viewViewModel = DetailMainViewModel(user: user)
            view.viewModel = viewViewModel
            
            viewController.detailView = view.configured()
            viewController.configure()
            
            let barViewController = DetailBarViewController()
            let barView = DetailBarView()
            let barViewViewModel = DetailBarViewModel()
            barView.viewModel = barViewViewModel
            
            barViewController.detailBarView = barView.configured()
            barViewController.configure()
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            rootViewController.view.window!.layer.add(transition, forKey: kCATransition)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                transition.duration = 1
                transition.type = CATransitionType.moveIn
//                barViewController.modalPresentationStyle = .overFullScreen
                transition.subtype = CATransitionSubtype.fromBottom
                self.viewController.view.window!.layer.add(transition, forKey: kCATransition)

                self.viewController.present(barViewController, animated: true, completion: nil)
            }

            
            viewController.modalPresentationStyle = .fullScreen
            rootViewController.present(viewController, animated: true)
            

//            rootViewController.present(barViewController, animated: true)
//            self.viewController.present(barViewController, animated: true)

            return .multiple(flowContributors: [
                .contribute(withNext: viewController),
                .contribute(withNext: barViewController)
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


