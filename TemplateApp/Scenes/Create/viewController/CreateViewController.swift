import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class CreateViewController: UIViewController, Stepper, TopBarViewControllerType {

    let steps = PublishRelay<Step>()

    var viewModel: CreateViewModelType!
    
    var createView: CreateViewType!
    
    var barViewController: TopBarViewController!

    private let disposeBag = DisposeBag()

    @discardableResult
    func configured() -> Self {
        configureBarView()
        configureView()
        
        setupViewModelBindings()
        setupViewBindings()
        setupBarBindings()

        return self
    }
}

//MARK: UI
private extension CreateViewController {
    func configureBarView() {
        view.addSubview(barViewController.view)
        barViewController.detailBarView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .red
        view.addSubview(createView)
        createView.snp.makeConstraints { maker in
            maker.top.equalTo(barViewController.view.snp_bottomMargin)
            maker.trailing.leading.bottom.equalToSuperview()
        }
    }
}

//MARK: Bindings
extension CreateViewController {
    private func setupViewModelBindings() {
        viewModel.onStepper
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    private func setupBarBindings() {
        barViewController.steps
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {

    }
}


