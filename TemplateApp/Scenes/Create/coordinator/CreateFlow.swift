import UIKit
import RxSwift
import RxFlow

class CreateFlow {
    private lazy var startViewController: CreateViewController = initStartViewController()
    private lazy var acceptViewController: CreateAcceptViewController = initAcceptViewController()
    private lazy var rootNavigationController = startViewController.navigationController
    private let saveTransaction: SaveTransaction

    private let disposeBag = DisposeBag()

    init(save saveTransaction: SaveTransaction) {
        self.saveTransaction = saveTransaction
    }
    
    private func initStartViewController() -> CreateViewController {
        startViewController = CreateViewController()
        let controllerViewModel = CreateViewModel()
        startViewController.viewModel = controllerViewModel
        
        let createView = CreateView()
        let createViewViewModel = CreateViewViewModel(save: saveTransaction)
        createView.viewModel = createViewViewModel
        createViewViewModel.bind(to: controllerViewModel).disposed(by: disposeBag)

        startViewController.createView = createView.configured()

        return startViewController.configured()
    }
    
    private func initAcceptViewController() -> CreateAcceptViewController {
        acceptViewController = CreateAcceptViewController()
        let acceptViewModel = CreateAcceptViewModel()
        acceptViewController.viewModel = acceptViewModel
        acceptViewController.createView = UIView()

        
        let barViewController = TopBarViewController()
        let barView = TopBarView(type: .close)
        let barViewViewModel = TopBarViewModel()
        barView.viewModel = barViewViewModel
        barViewController.closeStep = CreateStep.closeTop
        barViewController.detailBarView = barView.configured()

        acceptViewController.barViewController = barViewController.configured()
        
        return acceptViewController.configured()
    }
}


// MARK: - RxFlow
extension CreateFlow: Flow {
    var root: Presentable { startViewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CreateStep else { return navigateFromAppFlow(step) }

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: startViewController, withNextStepper: startViewController))
        case .acceptCreate:
            rootNavigationController?.pushViewController(acceptViewController, animated: true)
//            acceptViewController.modalPresentationStyle = .fullScreen
//            startViewController.present(acceptViewController, animated: true)
            return .one(flowContributor: .contribute(withNext: acceptViewController))
        case .closeTop:
//            startViewController.presentedViewController?.dismiss(animated: true)
            rootNavigationController?.popViewController(animated: true)
            return .none
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


