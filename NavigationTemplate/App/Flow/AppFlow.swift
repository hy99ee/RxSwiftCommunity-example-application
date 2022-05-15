import UIKit
import RxFlow

class AppFlow {
    static let shared = AppFlow()
    var openStep: Step!
    let rootViewController: UINavigationController
    
    let manager: Manager<Repository<User>>

    private init() {
        let rootViewController = UINavigationController()
        rootViewController.setNavigationBarHidden(false, animated: false)
        self.rootViewController = rootViewController

        manager = Manager(repository: AppRepository.shared)
    }
}

// MARK: - RxFlow
extension AppFlow: Flow {
    var root: Presentable {
        rootViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .toRoot: return openRoot()
        case .toHome: return openHome()
        case .toCreate: return openCreate()
        case .toSettings: return openSettings()

        case let .fromCreate(user): return manager.add(user)
        }
    }
}

// MARK: - Navigation cases
private extension AppFlow {
    func openRoot() -> FlowContributors {
        guard let _ = rootViewController.popToRootViewController(animated: true) else { return openHome() }

        return .none
    }

    func openHome() -> FlowContributors {
        let homeFlow = HomeFlow(root: rootViewController)

        Flows.use(homeFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: HomeStep.start)))
    }

    func openCreate() -> FlowContributors {
        let createFlow = CreateFlow()

        Flows.use(createFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(withNextPresentable: createFlow,
                                                 withNextStepper: OneStepper(withSingleStep: CreateStep.start)))
    }
    
    func openSettings() -> FlowContributors {
        let settingsFlow = SettingsFlow()

        Flows.use(settingsFlow, when: .ready) { [unowned self] root in
            self.rootViewController.present(root, animated: true)
        }

        return .one(flowContributor: .contribute(withNextPresentable: settingsFlow,
                                                 withNextStepper: OneStepper(withSingleStep: SettingsStep.start(user: manager.first))))
    }

    func fromCreate(_ user: User) -> FlowContributors {
        
        return manager.add(user)
    }
}
