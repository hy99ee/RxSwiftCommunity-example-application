import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()

    var viewModel: HomeViewModel!
    
    var homeView: HomeView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        configureView()
        
        setupViewModelBindings()
        setupViewBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func configureView() {
        homeView = HomeView()
        self.view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

//MARK: Bindings
extension HomeViewController {
    private func setupViewModelBindings() {
        viewModel.onTransition
            .subscribe(onNext: { [unowned self] in
                steps.accept($0) })
            .disposed(by: disposeBag)
 
        viewModel.onLoader
            .drive(homeView.showViews)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(homeView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {
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


