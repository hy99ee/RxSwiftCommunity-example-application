import RxFlow
import RxCocoa
import RxSwift

//MARK: - Observer view model types
protocol StepperViewModel {
    var stepper: AnyObserver<Step> { get }
}

protocol NextTapperViewModel {
    var tapNext: AnyObserver<Void> { get }
}

protocol UserSelecterViewModel {
    var selected: AnyObserver<User> { get }
}
protocol CloserViewModel {
    var close: PublishRelay<Void> { get }
}

//MARK: - Obseravable view model types
protocol StepableViewModel {
    var onStepper: Observable<Step> { get }
}
extension StepableViewModel {
    func bind(stepper stepperViewModelType: StepperViewModel) -> Disposable {
        self.onStepper
            .bind(to: stepperViewModelType.stepper)
    }
}

protocol SelectableViewModel {
    var onSelected: Observable<User> { get }
}
extension SelectableViewModel {
    func bind(selected selecterViewModelType: UserSelecterViewModel) -> Disposable {
        self.onSelected
            .bind(to: selecterViewModelType.selected)
    }
}

protocol ClosableViewModel {
    var onClose: Signal<Void> { get }
}
extension ClosableViewModel {
    func bind(closer closerViewModelType: CloserViewModel) -> Disposable {
        self.onClose
            .emit(to: closerViewModelType.close)
    }
}

protocol LoadableViewModel {
    var onLoader: Driver<Bool> { get }
}
