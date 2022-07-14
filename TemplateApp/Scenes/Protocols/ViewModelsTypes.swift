import RxFlow
import RxCocoa
import RxSwift

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
    func bind(on onCloseViewModelType: ClosableViewModel) -> Disposable {
        onCloseViewModelType.onClose
            .emit(to: close)
    }
}

protocol ToBackViewModel {
    var back: PublishRelay<Void> { get }
}
extension ToBackViewModel {
    func bind(on closableViewModelType: OnBackViewModel) -> Disposable {
        closableViewModelType.onBack
            .emit(to: back)
    }
}

protocol CreateTapViewModel {
    var tapCreate: PublishRelay<Void> { get }
}
extension CreateTapViewModel {
    func bind(onCreate onTapCreateView: onTapCreateView) -> Disposable {
        onTapCreateView.onTapCreate
            .emit(to: tapCreate)
    }
}

protocol NextTapperViewModel {
    var tapNext: PublishRelay<Void> { get }
}
extension NextTapperViewModel {
    func bind(on nextTapableViewModel: OnNextTapViewModel) -> Disposable {
        nextTapableViewModel.onTapNext
            .emit(to: tapNext)
    }
}

// MARK: - Obseravable view model types
protocol StepableViewModel {
    var onStepper: Observable<Step> { get }
}
extension StepableViewModel {
    func bind(to stepper: Stepper) -> Disposable {
        self.onStepper
            .bind(to: stepper.steps)
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

protocol OnBackViewModel {
    var onBack: Signal<Void> { get }
}
extension OnBackViewModel {
    func bind(to backerViewModelType: ToBackViewModel) -> Disposable {
        self.onBack
            .emit(to: backerViewModelType.back)
    }
}

protocol OnNextTapViewModel {
    var onTapNext: Signal<Void> { get }
}
extension OnNextTapViewModel {
    func bind(to nextTapperViewModelType: NextTapperViewModel) -> Disposable {
        self.onTapNext
            .emit(to: nextTapperViewModelType.tapNext)
    }
}

protocol OnLoadViewModel {
    var onLoader: Driver<Bool> { get }
}
