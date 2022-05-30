import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol CreateViewType: onTapCreateView, LoadingProcessView where Self: UIView {
    var viewModel: CreateViewViewModelType! { get }
}

class CreateView: UIView, CreateViewType {
    var viewModel: CreateViewViewModelType!

    private let nextText = "Create"
    private let closeText = "Close"
    
    let onTapCreate: Signal<Void>
    private let tapCreate: PublishRelay<Void>

    let disposeBag = DisposeBag()

    private var loadingViews: [UIView] = []

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
        button.setTitle(nextText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.snp.makeConstraints { $0.edges.equalToSuperview().inset(20) }
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle(closeText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.snp.makeConstraints { $0.edges.equalToSuperview().inset(20) }
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    lazy var viewsLoadingProcess = AnyObserver<Bool>(eventHandler: { [weak self] event in
        guard let event = event.element else { return }
        self?.loadingViews.forEach({ view in view.isHidden = !event })
    })

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        tapCreate = PublishRelay<Void>()
        onTapCreate = tapCreate.asSignal()
        
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configured() -> Self {
        self.configure()

        return self
    }
}

//MARK: Configure UI
private extension CreateView {
    func configure() {
        backgroundColor = .blue
        
        configureWelcomeLabel()
        configureCreateButton()
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
        loadingViews.append(welcomeLabel)
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
            maker.centerX.centerY.equalToSuperview().inset(50)
        }
        loadingViews.append(createButton)
    }

    func configureCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview().offset(100)
            maker.centerX.equalToSuperview()
        }
        loadingViews.append(closeButton)
    }
}

//MARK: Bindings
extension CreateView {
    private func setupBindings() {
        createButton.rx.tap
            .bind(to: viewModel.tapCreate)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.close)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(viewsLoadingProcess)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
