import UIKit
import RxCocoa
import RxSwift

protocol DetailBarViewType where Self: UIView {
    var viewModel: DetailBarViewModelType! { get }
}

class DetailBarView: UIView, DetailBarViewType {
    var viewModel: DetailBarViewModelType!
    
    private let disposeBag = DisposeBag()
    
    private lazy var closeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20

        return button
    }()

    func configured() -> Self {
        backgroundColor = .brown
        configureView()
        setupBindings()

        return self
    }
}

// MARK: UI
private extension DetailBarView {
    func configureView() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.trailing.equalToSuperview().inset(30)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
    }
}

//MARK: Bindings
private extension DetailBarView {
    func setupBindings() {
        closeButton.rx.tap
            .bind(to: viewModel.close)
            .disposed(by: disposeBag)
    }
}

