import UIKit
import RxSwift
import RxFlow

final class HomeFlow {
    private let viewController: HomeViewController

    init(manager: Manager<Repository<User>>) {
        let loadTransaction = (manager.onElements, manager.onIsLoad)
        let refreshTransaction = (manager.refresh, manager.onIsLoad)

        viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel

        let homeViewViewModel = HomeViewViewModel()
        let homeView = HomeView()

        let tableManager = TableViewHandler(load: loadTransaction, refresh: refreshTransaction)
        let tableViewModel = HomeViewTableViewModel(handler: tableManager)
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


