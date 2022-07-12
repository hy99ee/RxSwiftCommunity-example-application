import UIKit
import RxCocoa
import RxSwift
import SnapKit

enum TopBarViewConfigureType {
    case close
    case back
}

protocol TopBarViewType where Self: UIView {
    var viewModel: TopBarViewModelType! { get }
    var types: [TopBarViewConfigureType] { get }
}

class TopBarView: UIView, TopBarViewType {
    var viewModel: TopBarViewModelType!
    var types: [TopBarViewConfigureType]
    
    init(types: [TopBarViewConfigureType]) {
        self.types = types
    
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let disposeBag = DisposeBag()
    
    private let tapOffset = 10
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
    
    private lazy var backButton: UIView = {
        let button = UIImageView(image: UIImage(systemName: "chevron.backward.circle"))
        let view = UIView()
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().offset(tapOffset)
            maker.bottom.trailing.equalToSuperview().inset(tapOffset)
        }
        return view
    }()

    func configured() -> Self {
        
        types.forEach { type in
            switch type {
            case .close:
                configureCloseButton()
                setupCloseBindings()
            case .back:
                configureBackButton()
                setupBackBindings()
            }
        }

        return self
    }
}

// MARK: UI
private extension TopBarView {
    func configureCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().inset(6)
            maker.width.equalTo(30 + 2 * tapOffset)
            maker.height.equalTo(30 + 2 * tapOffset)
        }
    }
    
    func configureBackButton() {
        addSubview(backButton)
        backButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(6)
            maker.width.equalTo(30 + 2 * tapOffset)
            maker.height.equalTo(30 + 2 * tapOffset)
        }
    }
}

//MARK: Bindings
private extension TopBarView {
    func setupCloseBindings() {
        closeButton.rx.tapView()
            .emit(to: viewModel.close)
            .disposed(by: disposeBag)
    }
    
    func setupBackBindings() {
        backButton.rx.tapView()
            .emit(to: viewModel.back)
            .disposed(by: disposeBag)
    }
}

