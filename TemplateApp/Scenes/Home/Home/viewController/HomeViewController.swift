import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()

    var homeView: HomeViewType!
    var viewModel: HomeViewModelType!

    private let disposeBag = DisposeBag()

    let titleLabel = UILabel()
    private let didDisappear = PublishSubject<Void>()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        didDisappear.onNext(())
    }

    func setupView(_ homeView: HomeView) {
        self.homeView = homeView
        configure()
        setupViewModelBindings()
        setupViewBindings()
    }
}

private extension HomeViewController {
    func configure() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.centerX.equalToSuperview().inset(100)
        }
    }
}

//MARK: Bindings
extension HomeViewController {
    private func setupViewModelBindings() {
        viewModel.onStepper
            .subscribe(onNext: { [unowned self] in steps.accept($0) })
            .disposed(by: disposeBag)
 
        viewModel.onLoader
            .drive(homeView.viewsLoadingProcess)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(homeView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {
        didDisappear
            .map({ false })
            .bind(to: homeView.tableView.pullToRefresh.rx.isRefreshing)
            .disposed(by: disposeBag)
    
        homeView.onTapNext
            .emit(to: viewModel.tapNext)
            .disposed(by: disposeBag)

        homeView.onTapAbout
            .emit(to: viewModel.tapAbout)
            .disposed(by: disposeBag)

        homeView.onTapCreate
            .emit(to: viewModel.tapCreate)
            .disposed(by: disposeBag)
    }
}


