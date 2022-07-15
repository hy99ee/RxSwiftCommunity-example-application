import RxFlow
import RxSwift
import UIKit

final class HomeFlow: ToAppFlowNavigation {
    private let viewController: HomeViewController
    private let viewModel: HomeViewModelType
    var rootViewController: UINavigationController!

    private let disposeBag = DisposeBag()

    init(manager: Manager<Repository<User>>) {
        let loadTransaction = (manager.onElements, manager.onIsLoad)
        let refreshTransaction = (manager.refresh, manager.onIsLoad)

        viewController = HomeViewController()
        viewModel = HomeViewModel()
        viewController.viewModel = viewModel

        let navigationItem = HomeNavigationItem()
        viewController.homeNavigationItem = navigationItem

        let homeViewViewModel = HomeViewViewModel()
        let homeView = HomeView()
        homeView.viewModel = homeViewViewModel

        let tableHandler = TableViewHandler(load: loadTransaction, refresh: refreshTransaction)
        let tableViewModel = HomeViewTableViewModel(handler: tableHandler)
        tableViewModel.bind(to: viewModel).disposed(by: disposeBag)
        let tableView = HomeViewTableView()
        tableView.viewModel = tableViewModel
        homeView.tableView = tableView.configured()

        viewController.homeView = homeView.cofigured()
        viewController.configured()

        manager.refresh.onNext(())
    }
}

// MARK: - RxFlow
extension HomeFlow: Flow {
    var root: Presentable { viewController }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return navigateFromAppFlow(step) }

        print("Flow will be chancged by step: \(step.stepDescription)")

        switch step {
        case .start:
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))

        case let .toUser(user):
            return navigateToOpenUser(user)

        case .toDismissTop:
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
        let detailFlow = DetailFlow(root: viewController)

        return .one(flowContributor: .contribute(
            withNextPresentable: detailFlow,
            withNextStepper: OneStepper(withSingleStep: DetailtStep.start(user: user))
        ))
    }

    func navigateToCloseUser() -> FlowContributors {
        self.viewController.presentedViewController?.dismiss(animated: true)

        return .none
    }

    func navigateToAbout() -> FlowContributors {
        let about = createAboutController()
        self.viewController.present(about, animated: true)

        return .one(flowContributor: .contribute(withNext: about.barViewController))
    }

    func createAboutController() -> HomeAboutViewController {
        let viewController = HomeAboutViewController()
        let viewModel = HomeAboutViewModel()
        let view = HomeAboutView()
        viewController.viewModel = viewModel
        viewController.homeAboutView = view

        let barViewController = TopBarViewController()
        let barView = TopBarView(types: [.close])
        let barViewViewModel = TopBarViewModel()
        barView.viewModel = barViewViewModel

        barViewController.detailBarView = barView.configured()
        barViewController.closeStep = HomeStep.toDismissTop

        viewController.barViewController = barViewController.configured()

        viewController.modalPresentationStyle = .fullScreen

        return viewController.configured()
    }
}
