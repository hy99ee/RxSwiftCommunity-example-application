import UIKit
import RxSwift
import RxFlow

class CreateFlow {
    private let viewController: CreateViewController

    private let disposeBag = DisposeBag()

    init(save saveTransaction: SaveTransaction) {
        viewController = CreateViewController()
        let controllerViewModel = CreateViewModel()
        viewController.viewModel = controllerViewModel
        
        let createView = CreateView()
        let createViewViewModel = CreateViewViewModel(save: saveTransaction)
        createView.viewModel = createViewViewModel
        createViewViewModel.bind(closer: controllerViewModel).disposed(by: disposeBag)
        
        viewController.createView = createView.configured()
        viewController.configure()
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


