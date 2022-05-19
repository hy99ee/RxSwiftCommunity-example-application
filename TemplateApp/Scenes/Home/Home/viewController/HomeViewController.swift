import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()

    var viewModel: HomeViewModelType!

    var homeView: HomeViewType!

    private let disposeBag = DisposeBag()

    private let didDisappear = PublishSubject<Void>()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        didDisappear.onNext(())
    }
    
    func setupView(_ homeView: HomeView) {
        self.homeView = homeView
        view.addSubview(self.homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        setupViewModelBindings()
        setupViewBindings()
    }
}

//MARK: Bindings
extension HomeViewController {
    private func setupViewModelBindings() {
        viewModel.onTransition
            .subscribe(onNext: { [unowned self] in steps.accept($0) })
            .disposed(by: disposeBag)
 
        viewModel.onLoader
            .drive(homeView.endLoadingProcess)
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


