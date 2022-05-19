import UIKit
import RxCocoa
import RxSwift

protocol CreateViewType: onTapCreateView, LoadingProcessView where Self: UIView { }

class CreateView: UIView, CreateViewType {
    private let nextText: String = "Home"
    
    let onTapCreate: Signal<Void>
    private let tapCreate: PublishRelay<Void>

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
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 37)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    lazy var endLoadingProcess = AnyObserver<Bool>(eventHandler: { [weak self] in
        self?.createButton.isHidden = !$0.element!
        self?.welcomeLabel.isHidden = !$0.element!
    })

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        tapCreate = PublishRelay<Void>()
        onTapCreate = tapCreate.asSignal()
        
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Configure UI
private extension CreateView {
    func configure() {
        backgroundColor = .blue
        
        configureWelcomeLabel()
        configureCreateButton()
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
    
    func configureCreateButton() {
        addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview().inset(30)
            maker.height.width.equalTo(60)
        }
    }
}

//MARK: Bindings
extension CreateView {
    private func setupBindings() {
        createButton.rx.tap
            .bind(to: tapCreate)
            .disposed(by: disposeBag)
    }
}
