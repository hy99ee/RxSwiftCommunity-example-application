import UIKit
import RxCocoa
import RxSwift

protocol HomeNavigationItemType: onTapNextView where Self: UINavigationItem {
    var onTapAbout: Signal<Void> { get }
}

class HomeNavigationItem: UINavigationItem, HomeNavigationItemType {
    let onTapNext: Signal<Void>
    private let tapNext: PublishRelay<Void>

    let onTapAbout: Signal<Void>
    private let tapAbout: PublishRelay<Void>
    
    private let disposeBag = DisposeBag()
    
    private let settingImageView = UIImageView(image: UIImage(systemName: "info.circle"))
    private var settingsBarButtonItem: UIBarButtonItem!
    
    private let aboutImageView = UIImageView(image: UIImage(systemName: "gear"))
    private var aboutBarButtonItem: UIBarButtonItem!
    
    init() {
        tapNext = PublishRelay<Void>()
        onTapNext = tapNext.asSignal()

        tapAbout = PublishRelay<Void>()
        onTapAbout = tapAbout.asSignal()

        super.init()

        settingsBarButtonItem = UIBarButtonItem(customView: settingImageView)
        aboutBarButtonItem = UIBarButtonItem(customView: aboutImageView)

        configure()
        setupBindings()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: UI
private extension HomeNavigationItem {
    func configure() {
        leftBarButtonItem = aboutBarButtonItem
        rightBarButtonItem = settingsBarButtonItem
        
        settingImageView.snp.makeConstraints { $0.width.height.equalTo(25) }
        aboutImageView.snp.makeConstraints { $0.height.equalTo(25); $0.width.equalTo(27) }
    }
}

// MARK: Bindings
private extension HomeNavigationItem {
    func setupBindings() {
        aboutImageView.rx.tapView()
            .emit(to: tapAbout)
            .disposed(by: disposeBag)
 
        settingImageView.rx.tapView()
            .emit(to: tapNext)
            .disposed(by: disposeBag)
 
    }
}
