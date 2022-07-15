import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol CreateViewType: onTapNextView where Self: UIView {
    var viewModel: CreateViewViewModelType! { get }
}

class CreateView: UIView, CreateViewType {
    var viewModel: CreateViewViewModelType!

    private let nextText = "Create"
    private let closeText = "Close"

    let onTapNext: Signal<Void>
    private let tapNext: PublishRelay<Void>

    let disposeBag = DisposeBag()

    private let tapOffset = 10

    private lazy var fieldsView: FormViewController = {
        let viewController = FormViewController()
        viewController.view.backgroundColor = .white
        viewController.viewModel = CreateFieldsViewModel().configured()

        return viewController
    }()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private lazy var createButton: UIView = {
        let button = UIImageView(image: UIImage(systemName: "greaterthan.circle"))
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().offset(tapOffset)
            maker.bottom.trailing.equalToSuperview().inset(tapOffset)
        }
        return view
    }()

    private lazy var closeButton: UIView = {
        let button = UIImageView(image: UIImage(systemName: "xmark.circle"))
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().offset(tapOffset)
            maker.bottom.trailing.equalToSuperview().inset(tapOffset)
        }

        return view
    }()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        tapNext = PublishRelay<Void>()
        onTapNext = tapNext.asSignal()

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configured() -> Self {
        configure()
        setupBindings()

        return self
    }
}

// MARK: Configure UI
private extension CreateView {
    func configure() {
        backgroundColor = .white

        configureCreateButton()
        configureCloseButton()
        configureFieldsView()
        configureWelcomeLabel()
    }

    func configureCreateButton() {
        addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(5)
            maker.height.equalTo(40 + 2 * tapOffset)
            maker.width.equalTo(42 + 2 * tapOffset)
        }
    }

    func configureCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(15)
            maker.bottom.equalToSuperview().inset(5)
            maker.height.equalTo(40 + 2 * tapOffset)
            maker.width.equalTo(42 + 2 * tapOffset)
        }
    }

    func configureFieldsView() {
        addSubview(fieldsView.view)
        fieldsView.view.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            maker.bottom.equalTo(createButton.snp.top)
        }
    }

    func configureWelcomeLabel() {
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(50)
        }
    }
}

// MARK: Bindings
extension CreateView {
    private func setupBindings() {
        self.rx.tapView()
            .map { true }
            .emit(onNext: { [weak self] in self?.endEditing($0) })
            .disposed(by: disposeBag)

        fieldsView.viewModel.onUser
            .map { $0 == nil ? false : true }
            .drive(createButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        fieldsView.viewModel.onUser
            .map { $0 == nil ? 0.5 : 1 }
            .drive(createButton.rx.alpha)
            .disposed(by: disposeBag)

        createButton.rx.tapView()
            .withLatestFrom(fieldsView.viewModel.onUser)
            .compactMap { $0 }
            .emit(to: viewModel.user)
            .disposed(by: disposeBag)
    }
}
