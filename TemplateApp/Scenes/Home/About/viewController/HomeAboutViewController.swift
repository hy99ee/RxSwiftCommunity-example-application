import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class HomeAboutViewController: UINavigationController, Stepper {

    let steps = PublishRelay<Step>()

    var viewModel: HomeAboutViewModel!
    
    var homeView: HomeAboutView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
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

//MARK: Bindings
extension HomeAboutViewController {
    private func setupViewModelBindings() {
//        viewModel.onStepper
//            .subscribe(onNext: { [unowned self] in
//                steps.accept($0) })
//            .disposed(by: disposeBag)
//
//        viewModel.onLoader
//            .drive(homeView.showViews)
//            .disposed(by: disposeBag)
//
//        viewModel.onLoader
//            .drive(homeView.loadingView.rx.isHidden)
//            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {
//        homeView.onTapNext
//            .emit(to: viewModel.mover)
//            .disposed(by: disposeBag)
    }
}


