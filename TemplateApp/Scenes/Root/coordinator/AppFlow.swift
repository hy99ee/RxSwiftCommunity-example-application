import RxFlow
import RxSwift
import UIKit

class AppFlow {
    static let shared = AppFlow()
    let rootViewController: UINavigationController

    private let manager: Manager<Repository<User>>

    private let disposeBag = DisposeBag()

    private init() {
        let rootViewController = UINavigationController()

        self.rootViewController = rootViewController

        manager = Manager(repository: AppRepository())
    }
}

// MARK: - RxFlow
extension AppFlow: Flow {
    var root: Presentable {
        rootViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        showNavigationBar()
        switch step {
        case .toRoot: return openRoot()
        case .toHome: return openHome()
        case .toCreate: return openCreate()
        case .toSettings: return openSettings()
        }
    }
}

// MARK: - Navigation cases
private extension AppFlow {
    func openRoot() -> FlowContributors {
        guard rootViewController.popToRootViewController(animated: true) != nil else { return openHome() }

        return .none
    }

    func openHome() -> FlowContributors {
        let homeFlow = HomeFlow(manager: manager)

        Flows.use(homeFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: homeFlow,
            withNextStepper: OneStepper(withSingleStep: HomeStep.start)
        ))
    }

    func openCreate() -> FlowContributors {
        let saveTransaction = (manager.save, manager.onIsLoad)
        let createFlow = CreateFlow(save: saveTransaction)
        hideNavigationBar()
        Flows.use(createFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: createFlow,
            withNextStepper: OneStepper(withSingleStep: CreateStep.start)
        ))
    }
    func openSettings() -> FlowContributors {
        let settingsFlow = SettingsFlow()

        Flows.use(settingsFlow, when: .ready) { [unowned self] root in
            self.rootViewController.present(root, animated: true)
        }

        return .one(
            flowContributor: .contribute(
            withNextPresentable: settingsFlow,
            withNextStepper: OneStepper(withSingleStep: SettingsStep.start(user: manager.first))
            )
        )
    }
}

private extension AppFlow {
    var navigationBarTransition: CATransition {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        return transition
    }

    func hideNavigationBar() {
        rootViewController.navigationBar.layer.add(navigationBarTransition, forKey: kCATransition)

        rootViewController.setNavigationBarHidden(true, animated: false)
    }

    func showNavigationBar() {
        rootViewController.navigationBar.layer.add(navigationBarTransition, forKey: kCATransition)

        rootViewController.setNavigationBarHidden(false, animated: false)
    }
}
