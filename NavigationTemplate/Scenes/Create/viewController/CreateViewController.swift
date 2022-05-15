import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class CreateViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()

    var viewModel: CreateViewModel!
    
    var createView: CreateView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        configureView()
        
        setupViewModelBindings()
        setupViewBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    private func configureView() {
        createView = CreateView()
        self.view.addSubview(createView)
        createView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

//MARK: Bindings
extension CreateViewController {
    private func setupViewModelBindings() {
        viewModel.onTransition
            .subscribe(onNext: { [unowned self] in
                steps.accept($0) })
            .disposed(by: disposeBag)
 
        viewModel.onLoader
            .drive(createView.showViews)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(createView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {
        createView.onTapClose
            .emit(to: viewModel.tapCreate)
            .disposed(by: disposeBag)
    }
}


