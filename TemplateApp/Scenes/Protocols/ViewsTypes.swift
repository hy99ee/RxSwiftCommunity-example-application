import RxCocoa
import RxSwift
import SnapKit

protocol onTapNextView {
    var onTapNext: Signal<Void> { get }
}

protocol onTapCreateView {
    var onTapCreate: Signal<Void> { get }
}
extension onTapCreateView {
    func bind(toCreate createTapViewModel: CreateTapViewModel) -> Disposable {
        self.onTapCreate
            .emit(to: createTapViewModel.tapCreate)
    }
}

protocol LoadingProcessView {
    var loadingView: UIActivityIndicatorView { get }
    var viewsLoading: AnyObserver<Bool> { get }
    var loadingViews: [UIView] { get }

    func viewsLoadingProcess() -> AnyObserver<Bool>
}

extension LoadingProcessView where Self: UIView {
    func viewsLoadingProcess() -> AnyObserver<Bool> {
        AnyObserver<Bool>(eventHandler: { [weak self] event in
            guard let event = event.element else { return }
            self?.loadingViews.forEach({ view in view.isHidden = event })
        })
    }

    var viewsLoading: AnyObserver<Bool> { viewsLoadingProcess() }

    func configureLoadingView() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().inset(50)
        }
    }

    var loadingIndicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        indicator.tintColor = .black

        return indicator
    }
}
