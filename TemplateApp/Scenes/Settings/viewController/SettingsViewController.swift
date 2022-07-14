import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import UIKit

final class SettingsViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()

    var viewModel: SettingsViewModelType!

    var settingView: SettingViewType!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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

// MARK: Bindings
extension SettingsViewController {
    private func setupViewModelBindings() {
        viewModel.onStepper
            .bind(to: steps)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(settingView.viewsLoading)
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
