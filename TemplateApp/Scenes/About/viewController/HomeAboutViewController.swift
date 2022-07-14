import RxFlow
import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class HomeAboutViewController: UINavigationController, Stepper {
    let steps = PublishRelay<Step>()

    var viewModel: HomeAboutViewModel!

    var homeView: HomeAboutView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        setupViewModelBindings()
        setupViewBindings()
    }

    private func configureView() {
        homeView = HomeAboutView()
        self.view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: Bindings
extension HomeAboutViewController {
    private func setupViewModelBindings() {
    }

    private func setupViewBindings() {
    }
}
