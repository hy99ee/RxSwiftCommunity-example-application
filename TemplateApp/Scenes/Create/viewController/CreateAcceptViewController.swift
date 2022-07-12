import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class CreateAcceptViewController: UIViewController, Stepper, TopBarViewControllerType {
    let steps = PublishRelay<Step>()

    var viewModel: CreateAcceptViewModelType!
    
    var createView: UIView!

    var barViewController: TopBarViewController!

    private let disposeBag = DisposeBag()

    @discardableResult
    func configured() -> Self {
        view.backgroundColor = .white
        barViewController.view.backgroundColor = .red
        configureBarView()
        configureView()

        setupViewModelBindings()
        setupBarBindings()
        setupViewBindings()

        return self
    }
}

//MARK: UI
private extension CreateAcceptViewController {
    func configureBarView() {
        view.addSubview(barViewController.view)
        barViewController.detailBarView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.addSubview(createView)
        createView.snp.makeConstraints { maker in
            maker.top.equalTo(barViewController.view.snp_bottomMargin)
            maker.trailing.leading.bottom.equalToSuperview()
        }
    }
}

//MARK: Bindings
extension CreateAcceptViewController {
    private func setupViewModelBindings() {
        viewModel.onStepper.asSignal(onErrorJustReturn: CreateStep.close)
            .emit(to: steps)
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
