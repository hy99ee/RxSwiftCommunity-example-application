import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()

    var homeView: HomeViewType!
    var homeNavigationItem: HomeNavigationItem!
    var viewModel: HomeViewModelType!

    private let disposeBag = DisposeBag()

    private let viewVisibleState = PublishSubject<Bool>()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewVisibleState.onNext((false))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewVisibleState.onNext((true))
    }
    
    override var navigationItem: UINavigationItem {
        homeNavigationItem
    }

    @discardableResult
    func configured() -> Self {
        configure()
        setupViewModelBindings()
        setupViewBindings()
        setupNavigationViewBindings()

        return self
    }
}

private extension HomeViewController {
    func configure() {
        view.backgroundColor = .white
        
        view.addSubview(homeView)
        homeView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: Bindings
private extension HomeViewController {
    func setupViewModelBindings() {
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
    
    func setupViewBindings() {
        homeView.onTapCreate
            .emit(to: viewModel.tapCreate)
            .disposed(by: disposeBag)

        viewVisibleState
            .filter({ !$0 })
            .bind(to: homeView.tableView.pullToRefresh.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    func setupNavigationViewBindings() {
        homeNavigationItem.onTapNext
            .emit(to: viewModel.tapNext)
            .disposed(by: disposeBag)
        
        homeNavigationItem.onTapAbout
            .emit(to: viewModel.tapAbout)
            .disposed(by: disposeBag)
        
    }
}


