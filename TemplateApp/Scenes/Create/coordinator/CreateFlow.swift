import UIKit
import RxSwift
import RxFlow

class CreateFlow {
    private let viewController: CreateViewController

    init(save saveTransaction: SaveTransaction) {
        viewController = CreateViewController()
        let viewModel = CreateViewModel(save: saveTransaction)
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


