import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import UIKit

final class HomeAboutViewController: UINavigationController, Stepper, TopBarViewControllerType {
    let steps = PublishRelay<Step>()

    var viewModel: HomeAboutViewModel!

    var homeAboutView: HomeAboutView!

    var barViewController: TopBarViewController!

    private let disposeBag = DisposeBag()

    func configured() -> Self {
        configureBarView()
        configureView()

        setupViewModelBindings()
        setupViewBindings()

        return self
    }
}

// MARK: UI
private extension HomeAboutViewController {
    func configureBarView() {
        barViewController.addWithConstraints(parent: view)
    }

    func configureView() {
        view.addSubview(homeAboutView)
        homeAboutView.snp.makeConstraints { maker in
            maker.top.equalTo(barViewController.view.snp_bottomMargin)
            maker.trailing.leading.bottom.equalToSuperview()
        }
    }
}

// MARK: Bindings
private extension HomeAboutViewController {
    private func setupViewModelBindings() {
    }

    private func setupViewBindings() {
    }
}
