import UIKit
import RxFlow

class SettingsFlow {
    private let viewController: SettingsViewController

    init() {
        viewController = SettingsViewController()
    }
}

// MARK: - RxFlow
extension SettingsFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingsStep else { return navigateFromAppFlow(step) }

        switch step {
        case let .start(user):
            let viewModel = SettingsViewModel(user: user)
            viewController.viewModel = viewModel

            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
        }
    }
}
extension SettingsFlow: ToAppFlowNavigation {}

private extension SettingsFlow {
    func navigateTo() -> FlowContributors {
        return .none
    }
}


