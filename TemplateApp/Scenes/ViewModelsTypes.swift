import RxFlow
import RxCocoa
import RxSwift

protocol StepperViewModel {
    var onTransition: Observable<Step> { get }
}

protocol WithLoaderViewModel {
    var onLoader: Driver<Bool> { get }
}

protocol TapNextViewModel {
    var tapNext: AnyObserver<Void> { get }
}

protocol TapCreateViewModel {
    var tapCreate: AnyObserver<Void> { get }
}
