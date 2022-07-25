import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import UIKit

final class TopBarViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()

    var detailBarView: TopBarViewType!
    var closeStep: Step!
    var backStep: Step!

    private let disposeBag = DisposeBag()
    var height = 50

    @discardableResult
    func configured() -> Self {
        configureView()
        setupBindings()

        return self
    }

    func addWithConstraints(parent parentView: UIView, topOffest: Int = 0) {
        self.view.addSubview(detailBarView)
        parentView.addSubview(self.view)

        detailBarView.snp.makeConstraints { maker in
            maker.top.equalTo(parentView.safeAreaLayoutGuide).offset(topOffest)
            maker.leading.trailing.equalTo(parentView.safeAreaLayoutGuide)
            maker.height.equalTo(height)
        }
        self.view.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalTo(parentView)
            maker.bottom.equalTo(detailBarView)
        }
    }
}

// MARK: UI
private extension TopBarViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: Bindings
private extension TopBarViewController {
    func setupBindings() {
        detailBarView.viewModel.onClose
            .map { [unowned self] in closeStep }
            .emit(to: steps)
            .disposed(by: disposeBag)

        detailBarView.viewModel.onBack
            .map { [unowned self] in backStep }
            .emit(to: steps)
            .disposed(by: disposeBag)
    }
}
