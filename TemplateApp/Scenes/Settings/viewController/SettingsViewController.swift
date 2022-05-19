import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class SettingsViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()

    var viewModel: SettingsViewModel!
    
    var settingView: SettingsView!

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
        settingView = SettingsView()
        self.view.addSubview(settingView)
        settingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

//MARK: Bindings
extension SettingsViewController {
    private func setupViewModelBindings() {
        viewModel.onTransition
            .subscribe(onNext: { [unowned self] in
                steps.accept($0) })
            .disposed(by: disposeBag)
 
        viewModel.onLoader
            .drive(settingView.showViews)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(settingView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupViewBindings() {
        settingView.onTapNext
            .emit(to: viewModel.tapNext)
            .disposed(by: disposeBag)
    }
}


