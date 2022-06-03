import UIKit
import RxCocoa
import RxSwift

protocol DetailMainViewType where Self: UIView {
    var viewModel: DetailMainViewModelType! { get }
}

class DetailMainView: UIView, DetailMainViewType {
    var viewModel: DetailMainViewModelType!

    private let close = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 30)

        return label
    }()
    
    private lazy var ageLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 30)

        return label
    }()
    
    private lazy var idLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 30)

        return label
    }()
    
    func configured() -> Self {
        configureView()
        setupBindings()

        return self
    }
}

// MARK: UI
private extension DetailMainView {
    func configureView() {
        backgroundColor = .lightGray

        addSubview(titleLable)
        titleLable.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        addSubview(ageLable)
        ageLable.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview().offset(50)
            maker.trailing.leading.equalToSuperview()
        }
        
        addSubview(idLable)
        idLable.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview().offset(-50)
            maker.trailing.leading.equalToSuperview()
        }
    }
}

//MARK: Bindings
private extension DetailMainView {
    func setupBindings() {
        viewModel.onTitleLabel
            .drive(titleLable.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.onAgeLabel
            .drive(ageLable.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.onIdLabel
            .drive(idLable.rx.text)
            .disposed(by: disposeBag)
    }
}
