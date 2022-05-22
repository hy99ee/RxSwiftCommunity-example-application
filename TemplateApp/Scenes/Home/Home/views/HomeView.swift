import UIKit
import RxCocoa
import RxSwift

protocol HomeViewType: onTapCreateView, onTapNextView, LoadingProcessView where Self: UIView {
    var tableView: HomeViewTableView! { get }
    var onTapAbout: Signal<Void> { get }
}

class HomeView: UIView, HomeViewType {
    var viewModel: HomeViewViewModelType!
    var tableView: HomeViewTableView!
    
    let onTapNext: Signal<Void>
    private let tapNext: PublishRelay<Void>

    let onTapAbout: Signal<Void>
    private let tapAbout: PublishRelay<Void>
    
    let onTapCreate: Signal<Void>
    private let tapCreate: PublishRelay<Void>

    let disposeBag = DisposeBag()

    lazy var endLoadingProcess = AnyObserver<Bool>(eventHandler: { [weak self] event in
        guard let event = event.element else { return }
        self?.views.forEach({ view in view.isHidden = !event })
    })

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        indicator.color = .black
        
        return indicator
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
    
    private var views: [UIView] = []
    private let nextText: String = "Home"

    init() {
        tapNext = PublishRelay<Void>()
        onTapNext = tapNext.asSignal()

        tapAbout = PublishRelay<Void>()
        onTapAbout = tapAbout.asSignal()
        
        tapCreate = PublishRelay<Void>()
        onTapCreate = tapCreate.asSignal()
        
        super.init(frame: .zero)
        backgroundColor = .yellow
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cofigured() -> Self {
        configure()
        return self
    }
}

//MARK: View
private extension HomeView {
    func configure() {
        configureWelcomeLabel()
        configureAcceptButton()
        configureLoadingView()
        configureAboutButton()
        configureCreateButton()
        configureCollectionView()
        
        setupBindings()
    }
    
    func configureWelcomeLabel() {
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(50)
        }
        views.append(welcomeLabel)
    }
    
    func configureLoadingView() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(50)
        }
        loadingView.startAnimating()
    }
    
    func configureAcceptButton() {
        addSubview(acceptButton)
        acceptButton.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(30)
            maker.trailing.equalToSuperview().inset(20)
            maker.width.equalTo(100)
        }
        views.append(acceptButton)
    }

    func configureCollectionView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(200)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(acceptButton.snp_topMargin).offset(-20)
        }

        sendSubviewToBack(tableView)
    }

    func configureAboutButton() {
        addSubview(aboutButton)
        aboutButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.trailing.equalToSuperview().inset(30)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        views.append(aboutButton)
    }
    
    func configureCreateButton() {
        addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.leading.equalToSuperview().inset(30)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        views.append(createButton)
    }
}

//MARK: Bindings
extension HomeView {
    private func setupBindings() {
        acceptButton.rx.tap
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
