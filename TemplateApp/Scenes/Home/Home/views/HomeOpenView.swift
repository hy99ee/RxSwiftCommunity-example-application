import UIKit
import RxCocoa
import RxSwift

protocol HomeOpenViewType where Self: UIView {}

class HomeOpenView: UIView, HomeOpenViewType {
    var viewModel: HomeOpenViewModelType!
    var user: User

    private let close: PublishRelay<Void>
    
    private let disposeBag = DisposeBag()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10

        return button
    }()
    
    init(user: User) {
        self.user = user

        close = PublishRelay()

        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configured() -> Self {
        configure()
        
        return self
    }
}

// MARK: Configure UI
private extension HomeOpenView {
    func configure() {
        backgroundColor = .lightGray
        
        let label = UILabel()
        label.text = user.name

        addSubview(label)
        label.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(40)
            maker.trailing.equalToSuperview().inset(40)
            maker.width.height.equalTo(40)
        }

        bindView()
        bindViewModel()
    }
}

private extension HomeOpenView {
    func bindView() {
        closeButton.rx.tap
            .bind(to: close)
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        close
            .bind(to: viewModel.close)
            .disposed(by: disposeBag)
    }
}
