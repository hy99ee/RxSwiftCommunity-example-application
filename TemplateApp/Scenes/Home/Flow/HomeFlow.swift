import UIKit
import RxSwift
import RxFlow

final class HomeFlow {
    private let loadTransaction: LoadTransaction
    private let refreshTransaction: RefreshTransaction

    private let viewController: HomeViewController

    init(manager: Manager<Repository<User>>) {
        self.loadTransaction = (manager.onElements, manager.onIsLoad)
        self.refreshTransaction = (manager.refresh, manager.onIsLoad)

        viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel

        let homeViewViewModel = HomeViewViewModel(load: loadTransaction)
        let homeView = HomeView()

        let tableViewModel = HomeViewTableViewModel(refresh: refreshTransaction)
        let tableView = HomeViewTableView()
        tableView.viewModel = tableViewModel

        homeView.viewModel = homeViewViewModel
        homeView.tableView = tableView.configured()
    
        viewController.setupView(homeView.cofigured())
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

        case .toAbout:
            return navigateToAbout()
            
        case .toSettings:
            return navigateFromAppFlow(AppStep.toSettings)
            
        case .toCreate:
            return navigateFromAppFlow(AppStep.toCreate)
        }
    }
}
extension HomeFlow: ToAppFlowNavigation {}

private extension HomeFlow {
    func navigateToAbout() -> FlowContributors {
        let viewController = HomeAboutViewController()
        let viewModel = HomeAboutViewModel()
        viewController.viewModel = viewModel

        self.viewController.present(viewController, animated: true)

        return .none
    }
}


