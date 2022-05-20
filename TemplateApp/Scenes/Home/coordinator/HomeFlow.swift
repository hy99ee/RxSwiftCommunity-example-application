import UIKit
import RxSwift
import RxFlow

final class HomeFlow: ToAppFlowNavigation {
    private let viewController: HomeViewController
    private let disposeBag = DisposeBag()
    
    init(manager: Manager<Repository<User>>) {
        let loadTransaction = (manager.onElements, manager.onIsLoad)
        let refreshTransaction = (manager.refresh, manager.onIsLoad)

        viewController = HomeViewController()
        let homeViewModel = HomeViewModel()
        viewController.viewModel = homeViewModel

        let homeViewViewModel = HomeViewViewModel()
        let homeView = HomeView()

        let tableHandler = TableViewHandler(load: loadTransaction, refresh: refreshTransaction)
        let tableViewModel = HomeViewTableViewModel(handler: tableHandler)
        let tableView = HomeViewTableView()
        tableView.viewModel = tableViewModel

        homeView.viewModel = homeViewViewModel
        homeView.tableView = tableView.configured()
    
        viewController.setupView(homeView.cofigured())
        
        bindSelected(on: tableViewModel, to: homeViewModel)
    }
}

// MARK: - RxFlow
extension HomeFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return navigateFromAppFlow(step) }

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
            
        case let .toUser(user):
            return navigateToOpenUser(user)

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
        let viewController = UIViewController()
        viewController.view.backgroundColor = .lightGray
        
        let view = UILabel()
        viewController.view.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.text = user.name
        

        self.viewController.present(viewController, animated: true)

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
    func bindSelected(on onSelected: onSelectedViewModel, to selected: SelectedViewModel) {
        onSelected.onSelected
            .bind(to: selected.selected)
            .disposed(by: disposeBag)
    }
}


