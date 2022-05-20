import UIKit
import RxCocoa
import RxSwift

protocol HomeOpenViewType: onCloseView where Self: UIView {}

class HomeOpenView: UIView, HomeOpenViewType {
    var onClose: Signal<Void>
    private let close: PublishRelay<Void>
    
    init() {
        close = PublishRelay()
        onClose = close.asSignal()

        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure UI
private extension HomeOpenView {
    func configure() {
        
    }
}
