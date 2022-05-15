import UIKit
import RxCocoa
import RxSwift

class HomeView: UIView {
    private let nextText: String = "Home"
    
    let onTapNext: Signal<Void>
    private let tapNext: PublishRelay<Void>

    let onTapAbout: Signal<Void>
    private let tapAbout: PublishRelay<Void>
    
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
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 37)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    private lazy var aboutButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .lightGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    private lazy var createButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("New", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    lazy var showViews = AnyObserver<Bool>(eventHandler: { [weak self] in
        self?.nextButton.isHidden = !$0.element!
        self?.welcomeLabel.isHidden = !$0.element!
    })

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        tapNext = PublishRelay<Void>()
        onTapNext = tapNext.asSignal()

        tapAbout = PublishRelay<Void>()
        onTapAbout = tapAbout.asSignal()
        
        tapCreate = PublishRelay<Void>()
        onTapCreate = tapCreate.asSignal()
        
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: View
private extension HomeView {
    func configure() {
        backgroundColor = .yellow
        
        configureWelcomeLabel()
        configureLoginButton()
        configureLoadingView()
        configureAboutButton()
        configureCreateButton()

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
    
    func configureLoginButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(150)
        }
    }
    
    func configureAboutButton() {
        addSubview(aboutButton)
        aboutButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.trailing.equalToSuperview().inset(30)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
    }
    
    func configureCreateButton() {
        addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.leading.equalToSuperview().inset(30)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
    }
}

//MARK: Bindings
extension HomeView {
    private func setupBindings() {
        nextButton.rx.tap
            .bind(to: tapNext)
            .disposed(by: disposeBag)
                
        aboutButton.rx.tap
            .map({ _ -> CGFloat in 0.75 })
            .bind(to: aboutButton.rx.alpha)
            .disposed(by: disposeBag)
                
        aboutButton.rx.tap
            .delay(.milliseconds(250), scheduler: MainScheduler.instance)
            .map({ _ -> CGFloat in 1 })
            .bind(to: aboutButton.rx.alpha)
            .disposed(by: disposeBag)
                
        aboutButton.rx.tap
            .bind(to: tapAbout)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(to: tapCreate)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .map({ _ -> CGFloat in 0.3 })
            .bind(to: createButton.rx.alpha)
            .disposed(by: disposeBag)
                
        createButton.rx.tap
            .delay(.milliseconds(250), scheduler: MainScheduler.instance)
            .map({ _ -> CGFloat in 1 })
            .bind(to: createButton.rx.alpha)
            .disposed(by: disposeBag)
    }
}
