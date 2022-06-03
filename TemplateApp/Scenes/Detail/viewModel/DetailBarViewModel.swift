import RxCocoa
import RxSwift

protocol DetailBarViewModelType: CloserViewModel, ClosableViewModel {}

class DetailBarViewModel: DetailBarViewModelType {
    let close: PublishRelay<Void>
    let onClose: Signal<Void>

    init() {
        close = PublishRelay()
        onClose = close.asSignal()
    }
}
