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

protocol UserViewModel {
    var user: AnyObserver<User> { get }
}
extension UserViewModel {
    func bind(on selectableViewModelType: OnUserViewModel) -> Disposable {
        selectableViewModelType.onUser
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

protocol BackerViewModel {
    var back: PublishRelay<Void> { get }
}
extension BackerViewModel {
    func bind(on closableViewModelType: BackableViewModel) -> Disposable {
        closableViewModelType.onBack
            .emit(to: back)
    }
}

protocol NextTapperViewModel {
    var tapNext: PublishRelay<Void> { get }
}
extension NextTapperViewModel {
    func bind(on nextTapableViewModel: NextTapableViewModel) -> Disposable {
        nextTapableViewModel.onTapNext
            .emit(to: tapNext)
    }
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

protocol OnUserViewModel {
    var onUser: Observable<User> { get }
}
extension OnUserViewModel {
    func bind(to selecterViewModelType: UserViewModel) -> Disposable {
        self.onUser
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

protocol BackableViewModel {
    var onBack: Signal<Void> { get }
}
extension BackableViewModel {
    func bind(to backerViewModelType: BackerViewModel) -> Disposable {
        self.onBack
            .emit(to: backerViewModelType.back)
    }
}

protocol NextTapableViewModel {
    var onTapNext: Signal<Void> { get }
}
extension NextTapableViewModel {
    func bind(to nextTapperViewModelType: NextTapperViewModel) -> Disposable {
        self.onTapNext
            .emit(to: nextTapperViewModelType.tapNext)
    }
}

protocol LoadableViewModel {
    var onLoader: Driver<Bool> { get }
}
