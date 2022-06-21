import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol DetailBarViewType where Self: UIView {
    var viewModel: DetailBarViewModelType! { get }
}

class DetailBarView: UIView, DetailBarViewType {
    var viewModel: DetailBarViewModelType!
    
    private let disposeBag = DisposeBag()
    
    private let tapOffset = 10
    private lazy var closeButton: UIView = {
        let button = UIImageView(image: UIImage(systemName: "xmark.circle"))
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().offset(tapOffset)
            maker.bottom.trailing.equalToSuperview().inset(tapOffset)
        }
        return view
    }()

    func configured() -> Self {
        configureButton()
        setupBindings()

        return self
    }
}

// MARK: UI
private extension DetailBarView {
    func configureButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().inset(4)
            maker.width.equalTo(25 + 2 * tapOffset)
            maker.height.equalTo(25 + 2 * tapOffset)
        }
    }
}

//MARK: Bindings
private extension DetailBarView {
    func setupBindings() {
        closeButton.rx.tapView()
            .emit(to: viewModel.close)
            .disposed(by: disposeBag)
    }
}

