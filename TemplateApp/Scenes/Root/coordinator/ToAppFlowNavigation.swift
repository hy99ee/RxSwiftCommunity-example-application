import RxFlow

protocol ToAppFlowNavigation {
    func navigateFromAppFlow(_ step: Step) -> FlowContributors
    func navigateToRoot() -> FlowContributors
}

extension ToAppFlowNavigation {
    var appFlow: AppFlow {
        AppFlow.shared
    }

    func navigateFromAppFlow(_ step: Step) -> FlowContributors {
        guard let appStep = step as? AppStep else { return .none }

        return navigateToAppFlowScene(step: appStep)
    }

    func navigateToRoot() -> FlowContributors {
        navigateToAppFlowRoot()
    }

    private func navigateToAppFlowScene(step: Step) -> FlowContributors {
        appFlow.navigate(to: step)
    }

    private func navigateToAppFlowRoot() -> FlowContributors {
        appFlow.navigate(to: AppStep.toRoot)
    }
}
