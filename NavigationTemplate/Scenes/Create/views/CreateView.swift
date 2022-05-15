import UIKit
import RxCocoa
import RxSwift

class CreateView: UIView {
    private let nextText: String = "Home"
    
    let onTapClose: Signal<Void>
    private let tapClose: PublishRelay<Void>

    let disposeBag = DisposeBag()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        return indicator
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 37)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    lazy var showViews = AnyObserver<Bool>(eventHandler: { [weak self] in
        self?.closeButton.isHidden = !$0.element!
        self?.welcomeLabel.isHidden = !$0.element!
    })

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        tapClose = PublishRelay<Void>()
        onTapClose = tapClose.asSignal()
        
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure views
private extension CreateView {
    func configure() {
        backgroundColor = .blue
        
        configureWelcomeLabel()
        configureCloseButton()
        configureLoadingView()
        
        setupBindings()
    }

    func configureWelcomeLabel() {
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(50)
        }
    }
    
    func configureLoadingView() {
        addSubview(loadingView)
        
        loadingView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(50)
        }
        
        loadingView.startAnimating()
    }
    
    func configureCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview().inset(30)
            maker.height.width.equalTo(60)
        }
    }
}

//MARK: Bindings
extension CreateView {
    private func setupBindings() {
        closeButton.rx.tap
            .bind(to: tapClose)
            .disposed(by: disposeBag)
//
//        nextButton.rx.tap
//            .map({ _ -> CGFloat in 0.75 })
//            .bind(to: nextButton.rx.alpha)
//            .disposed(by: disposeBag)
//
//        nextButton.rx.tap
//            .delay(.milliseconds(250), scheduler: MainScheduler.instance)
//            .map({ _ -> CGFloat in 1 })
//            .bind(to: nextButton.rx.alpha)
//            .disposed(by: disposeBag)
    }
}
