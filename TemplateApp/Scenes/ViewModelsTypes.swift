import RxFlow
import RxCocoa
import RxSwift

// Observer view model types
protocol NextTapperViewModel {
    var tapNext: AnyObserver<Void> { get }
}

protocol CreateTapperViewModel {
    var tapCreate: AnyObserver<Void> { get }
}

protocol UserSelecterViewModel {
    var selected: AnyObserver<User> { get }
}
protocol CloserViewModel {
    var close: PublishRelay<Void> { get }
}

// Obseravable view model types
protocol StepableViewModel {
    var onTransition: Observable<Step> { get }
}

protocol SelectableViewModel {
    var onSelected: Observable<User> { get }
}

protocol LoadableViewModel {
    var onLoader: Driver<Bool> { get }
}

protocol ClosableViewModel {
    var onClose: Signal<Void> { get }
}
