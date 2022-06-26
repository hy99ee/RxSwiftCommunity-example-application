import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class CreateViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()

    var viewModel: CreateViewModelType!
    
    var createView: CreateViewType!

    private let disposeBag = DisposeBag()

    func configure() {
        self.configureView()
        self.setupViewModelBindings()
        self.setupViewBindings()
    }
}

//MARK: UI
private extension CreateViewController {
     func configureView() {
         view.backgroundColor = .white
         self.view.addSubview(createView)
         createView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

//MARK: Bindings
extension CreateViewController {
    private func setupViewModelBindings() {
        viewModel.onStepper
            .subscribe(onNext: { [unowned self] in
                steps.accept($0) })
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {

    }
}


