import UIKit
import RxCocoa
import RxSwift

protocol HomeViewType: onTapCreateView, LoadingProcessView where Self: UIView {
    var tableView: HomeViewTableView! { get }
}

class HomeView: UIView, HomeViewType {
    var viewModel: HomeViewViewModelType!
    var tableView: HomeViewTableView!

    let onTapCreate: Signal<Void>
    private let tapCreate: PublishRelay<Void>

    let disposeBag = DisposeBag()

    private let tapOffset = 10
    private lazy var createButton: UIView = {
        let button = UIImageView(image: UIImage(systemName: "plus.circle"))
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().offset(tapOffset)
            maker.bottom.trailing.equalToSuperview().inset(tapOffset)
        }
        return view
    }()

    lazy var viewsLoadingProcess = AnyObserver<Bool>(eventHandler: { [weak self] event in
        guard let event = event.element else { return }
        self?.loadingViews.forEach({ view in view.isHidden = !event })
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

    var loadingViews: [UIView] = []

    init() {
        tapCreate = PublishRelay<Void>()
        onTapCreate = tapCreate.asSignal()

        super.init(frame: .zero)
        backgroundColor = .init(white: 0, alpha: 0.3)
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
        configureLoadingView()
        configureTableView()
        configureCreateButtonView()
        
        setupBindings()
    }
    
    func configureCreateButtonView() {
        addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(5)
            maker.height.equalTo(40 + 2 * tapOffset)
            maker.width.equalTo(42 + 2 * tapOffset)
        }
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

    func configureTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

    }

}

//MARK: Bindings
extension HomeView {
    private func setupBindings() {
        createButton.rx.tapView()
            .emit(to: tapCreate)
            .disposed(by: disposeBag)
        
        createButton.rx.tapView()
            .map({ _ -> CGFloat in 0.3 })
            .emit(to: createButton.rx.alpha)
            .disposed(by: disposeBag)
                
        createButton.rx.tapView()
            .delay(.milliseconds(250))
            .map({ _ -> CGFloat in 1 })
            .emit(to: createButton.rx.alpha)
            .disposed(by: disposeBag)
    }
}
