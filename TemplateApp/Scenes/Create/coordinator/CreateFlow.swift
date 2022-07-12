import UIKit
import RxSwift
import RxFlow

class CreateFlow {
    private lazy var startViewController: CreateViewController = createStartViewController()
    private var acceptViewController: CreateAcceptViewController!
    private lazy var rootNavigationController = startViewController.navigationController

    private let saveTransaction: SaveTransaction

    private let disposeBag = DisposeBag()

    init(save saveTransaction: SaveTransaction) {
        self.saveTransaction = saveTransaction
    }
    
    private func createStartViewController() -> CreateViewController {
        startViewController = CreateViewController()
        let controllerViewModel = CreateViewModel()
        startViewController.viewModel = controllerViewModel
        
        let createView = CreateView()
        let createViewViewModel = CreateViewViewModel()
        createView.viewModel = createViewViewModel
        controllerViewModel.bind(on: createViewViewModel).disposed(by: disposeBag)

        startViewController.createView = createView.configured()
        
        let barViewController = TopBarViewController()
        let barView = TopBarView(types: [.close])
        let barViewViewModel = TopBarViewModel()
        barView.viewModel = barViewViewModel
        barViewController.closeStep = CreateStep.close
        barViewController.detailBarView = barView.configured()
        
        startViewController.barViewController = barViewController.configured()

        return startViewController.configured()
    }
    
    private func createAcceptViewController(user: User) -> CreateAcceptViewController {
        acceptViewController = CreateAcceptViewController()
        let acceptViewModel = CreateAcceptViewModel(user: user, save: saveTransaction)
        acceptViewController.viewModel = acceptViewModel
        acceptViewController.createAcceptView = UIView()

        
        let barViewController = TopBarViewController()
        let barView = TopBarView(types: [.close, .back])
        let barViewViewModel = TopBarViewModel()
        barView.viewModel = barViewViewModel
        barViewController.backStep = CreateStep.closeTop
        barViewController.closeStep = CreateStep.close
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
            return .one(flowContributor: .contribute(withNext: startViewController))
        case let .saveStep(user):
            let saveViewController = createAcceptViewController(user: user)
            rootNavigationController?.pushViewController(saveViewController, animated: true)
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


