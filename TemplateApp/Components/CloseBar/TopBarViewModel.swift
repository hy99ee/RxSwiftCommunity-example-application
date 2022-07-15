import RxCocoa
import RxSwift

protocol TopBarViewModelType: CloserViewModel, ClosableViewModel, ToBackViewModel, OnBackViewModel {}

class TopBarViewModel: TopBarViewModelType {
    let close: PublishRelay<Void>
    let onClose: Signal<Void>

    let back: PublishRelay<Void>
    let onBack: Signal<Void>

    init() {
        close = PublishRelay()
        onClose = close.asSignal()

        back = PublishRelay()
        onBack = back.asSignal()
    }
}
