import UIKit
import RxSwift
import RxFlow

class AppFlow {
    static let shared = AppFlow()
    let rootViewController: UINavigationController
    
    let manager: Manager<Repository<User>>
    
    private let disposeBag = DisposeBag()

    private init() {
        let rootViewController = UINavigationController()
        rootViewController.setNavigationBarHidden(false, animated: false)
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
        guard let _ = rootViewController.popToRootViewController(animated: true) else { return openHome() }

        return .none
    }

    func openHome() -> FlowContributors {
        let homeFlow = HomeFlow(onUsers: manager.elements.asObservable())

        Flows.use(homeFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }

        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: HomeStep.start)))
    }

    func openCreate() -> FlowContributors {
        let createFlow = CreateFlow(save: manager.saveTransaction)

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
}

//// MARK: - Bindings
//private extension AppFlow {
//    func bindFlow(_ flow: Flow) {
//        switch flow {
//        case let flow as HomeFlow:
//            manager.elements()
//                .debug("----------> ")
//                .subscribe(flow.users)
//                .disposed(by: disposeBag)
//        default: break
//        }
//    }
//}
    
    
