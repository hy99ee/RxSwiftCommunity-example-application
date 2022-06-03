import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class DetailBarViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()
    private let emitSteps = PublishSubject<Step>()
    
    var detailBarView: DetailBarViewType!

    private let disposeBag = DisposeBag()

    func configure() {
        configureView()

        setupBindings()
    }
}

//MARK: UI
private extension DetailBarViewController {
    func configureView() {

        view.addSubview(detailBarView)
        detailBarView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

//MARK: Bindings
private extension DetailBarViewController {
    func setupBindings() {
        detailBarView.viewModel.onClose
            .map({ _ -> Step in DetailtStep.close })
            .emit(onNext: { [unowned self] in self.steps.accept($0) })
            .disposed(by: disposeBag)
    }
}


