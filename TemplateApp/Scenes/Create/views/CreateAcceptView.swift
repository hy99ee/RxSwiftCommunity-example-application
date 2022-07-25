import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol CreateAcceptViewType: onTapCreateView, LoadingProcessView where Self: UIView {
    var viewModel: CreateAcceptViewModelType! { get }
}

class CreateAcceptView: UIView, CreateAcceptViewType {
    let onTapCreate: Signal<Void>
    let tapCreate: PublishRelay<Void>

    var viewModel: CreateAcceptViewModelType!

    var loadingViews: [UIView]

    private let disposeBag = DisposeBag()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10

        return button
    }()

    private lazy var userFace = UIImageView(image: UIImage(named: "User"))
    private lazy var userName = UILabel()
    private lazy var userAge = UILabel()

    lazy var loadingView = loadingIndicator

    init() {
        loadingViews = []
        tapCreate = PublishRelay()
        onTapCreate = tapCreate.asSignal()

        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configured() -> Self {
        configure()
        setupBindings()

        return self
    }
}

// MARK: UI
private extension CreateAcceptView {
    func configure() {
        self.backgroundColor = .white

        configureUserFace()
        configureCreateButton()
        configureUserTitles()
        configureLoadingView()
    }

    func configureCreateButton() {
        self.addSubview(saveButton.appendTo(&loadingViews))
        saveButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(50)
        }
    }

    func configureUserFace() {
        self.addSubview(userFace)
        userFace.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }

    func configureUserTitles() {
        self.addSubview(userName)
        self.addSubview(userAge)
        userName.snp.makeConstraints { maker in
            maker.bottom.equalTo(userFace.snp.topMargin)
            maker.centerX.equalToSuperview()
        }
        userAge.snp.makeConstraints { maker in
            maker.top.equalTo(userFace.snp.bottomMargin)
            maker.centerX.equalToSuperview()
        }
    }
}

// MARK: Bindings
private extension CreateAcceptView {
    func setupBindings() {
        saveButton.rx.tap
            .bind(to: tapCreate)
            .disposed(by: disposeBag)

        viewModel
            .bind(onCreate: self)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(viewsLoading)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .map { !$0 }
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.onLoader
            .drive(loadingView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.onUserName
            .drive(userName.rx.text)
            .disposed(by: disposeBag)

        viewModel.onUserDescription
            .drive(userAge.rx.text)
            .disposed(by: disposeBag)
    }
}
