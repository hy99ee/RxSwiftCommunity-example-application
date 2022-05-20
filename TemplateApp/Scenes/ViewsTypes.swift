import RxCocoa
import RxSwift

protocol onTapNextView {
    var onTapNext: Signal<Void> { get }
}

protocol onTapCreateView {
    var onTapCreate: Signal<Void> { get }
}

protocol LoadingProcessView {
    var loadingView: UIActivityIndicatorView { get }
    var endLoadingProcess: AnyObserver<Bool> { get }
}
