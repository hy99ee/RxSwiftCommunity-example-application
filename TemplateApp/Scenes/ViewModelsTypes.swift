import RxFlow
import RxCocoa
import RxSwift

//MARK: - Observer view model types
protocol StepperViewModel {
    var stepper: AnyObserver<Step> { get }
}
extension StepperViewModel {
    func bind(on stepableViewModel: StepableViewModel) -> Disposable {
        stepableViewModel.onStepper
            .bind(to: stepper)
    }
}

protocol UserSelecterViewModel {
    var user: AnyObserver<User> { get }
}
extension UserSelecterViewModel {
    func bind(on selectableViewModelType: SelectableViewModel) -> Disposable {
        selectableViewModelType.onSelected
            .bind(to: user)
    }
}

protocol CloserViewModel {
    var close: PublishRelay<Void> { get }
}
extension CloserViewModel {
    func bind(on closableViewModelType: ClosableViewModel) -> Disposable {
        closableViewModelType.onClose
            .emit(to: close)
    }
}

protocol NextTapperViewModel {
    var tapNext: AnyObserver<Void> { get }
}

//MARK: - Obseravable view model types
protocol StepableViewModel {
    var onStepper: Observable<Step> { get }
}
extension StepableViewModel {
    func bind(to stepperViewModelType: StepperViewModel) -> Disposable {
        self.onStepper
            .bind(to: stepperViewModelType.stepper)
    }
}

protocol SelectableViewModel {
    var onSelected: Observable<User> { get }
}
extension SelectableViewModel {
    func bind(to selecterViewModelType: UserSelecterViewModel) -> Disposable {
        self.onSelected
            .bind(to: selecterViewModelType.user)
    }
}

protocol ClosableViewModel {
    var onClose: Signal<Void> { get }
}
extension ClosableViewModel {
    func bind(to closerViewModelType: CloserViewModel) -> Disposable {
        self.onClose
            .emit(to: closerViewModelType.close)
    }
}

protocol LoadableViewModel {
    var onLoader: Driver<Bool> { get }
}
