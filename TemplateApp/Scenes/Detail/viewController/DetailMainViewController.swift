import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import UIKit

final class DetailMainViewController: UIViewController, Stepper, TopBarViewControllerType {
    let steps = PublishRelay<Step>()

    var detailView: DetailMainViewType!
    var barViewController: TopBarViewController!

    private let disposeBag = DisposeBag()

    @discardableResult
    func configured() -> Self {
        view.backgroundColor = .white

        configureBarView()
        configureView()

        setupViewModelBindings()
        setupViewBindings()

        return self
    }
}

// MARK: UI
private extension DetailMainViewController {
    func configureBarView() {
        barViewController.addWithConstraints(parent: view, topOffest: 5)
    }

    func configureView() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { maker in
            maker.top.equalTo(barViewController.view.snp_bottomMargin)
            maker.trailing.leading.bottom.equalToSuperview()
        }
    }
}

// MARK: Bindings
private extension DetailMainViewController {
    func setupViewModelBindings() {
    }

    func setupViewBindings() {
    }
}
