import UIKit
import RxFlow

class CreateFlow {
    private let viewController: CreateViewController

    init() {
        viewController = CreateViewController()
        let viewModel = CreateViewModel()
        viewController.viewModel = viewModel
    }
}

// MARK: - RxFlow
extension CreateFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CreateStep else { return navigateFromAppFlow(step) }

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
        case let .create(user):
            return navigateFromAppFlow(AppStep.fromCreate(user: user))
        case .close:
            return navigateToRoot()
        }
    }
}
extension CreateFlow: ToAppFlowNavigation {}

private extension CreateFlow {
    func navigateTo() -> FlowContributors {
        return .none
    }
}


