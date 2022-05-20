import RxCocoa
import RxSwift

protocol HomeOpenViewModelType: ClosableViewModel, CloserViewModel {}

class HomeOpenViewModel: HomeOpenViewModelType {
    let onClose: Signal<Void>
    let close: PublishRelay<Void>

    init() {
        close = PublishRelay()
        onClose = close.asSignal()
    }
}
