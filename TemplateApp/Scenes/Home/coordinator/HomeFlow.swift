import UIKit
import RxSwift
import RxFlow

final class HomeFlow: ToAppFlowNavigation {
    private let viewController: HomeViewController
    private let viewModel: HomeViewModelType

    private let disposeBag = DisposeBag()
    
    init(manager: Manager<Repository<User>>) {
        let loadTransaction = (manager.onElements, manager.onIsLoad)
        let refreshTransaction = (manager.refresh, manager.onIsLoad)

        viewController = HomeViewController()
        viewModel = HomeViewModel()
        viewController.viewModel = viewModel

        let homeViewViewModel = HomeViewViewModel()
        let homeView = HomeView()
        homeView.viewModel = homeViewViewModel

        let tableHandler = TableViewHandler(load: loadTransaction, refresh: refreshTransaction)
        let tableViewModel = HomeViewTableViewModel(handler: tableHandler)
        let tableView = HomeViewTableView()
        tableView.viewModel = tableViewModel
        homeView.tableView = tableView.configured()

        viewController.setupView(homeView.cofigured())
        bindSelectable(on: tableViewModel, to: viewModel)
        
        manager.refresh.onNext(())
    }
}

// MARK: - RxFlow
extension HomeFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return navigateFromAppFlow(step) }

        viewController.titleLabel.text = step.stepDescription

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))

        case let .toUser(user):
            return navigateToOpenUser(user)

        case .toCloseUser:
            return navigateToCloseUser()

        case .toAbout:
            return navigateToAbout()

        case .toSettings:
            return navigateFromAppFlow(AppStep.toSettings)

        case .toCreate:
            return navigateFromAppFlow(AppStep.toCreate)
        }
    }
}

// MARK: Navigation
private extension HomeFlow {
    func navigateToOpenUser(_ user: User) -> FlowContributors {
        let openView = HomeOpenView(user: user)
        let openViewModel = HomeOpenViewModel()
        openView.viewModel = openViewModel
        let viewController = UIViewController()
        viewController.view = openView.configured()
        viewController.isModalInPresentation = true

        bindClosable(on: openViewModel, to: viewModel)

        self.viewController.present(viewController, animated: true)

        return .none
    }
    
    func navigateToCloseUser() -> FlowContributors {
        self.viewController.presentedViewController?.dismiss(animated: true)
        return .none
    }
    
    func navigateToAbout() -> FlowContributors {
        let viewController = HomeAboutViewController()
        let viewModel = HomeAboutViewModel()
        viewController.viewModel = viewModel

        self.viewController.present(viewController, animated: true)

        return .none
    }
}

// MARK: Bindings
private extension HomeFlow {
    func bindSelectable(on onSelected: SelectableViewModel, to selected: UserSelecterViewModel) {
        onSelected.onSelected
            .bind(to: selected.selected)
            .disposed(by: disposeBag)
        
    }
    
    func bindClosable(on onClose: ClosableViewModel, to close: CloserViewModel) {
        onClose.onClose
            .emit(to: close.close)
            .disposed(by: disposeBag)
    }
}


