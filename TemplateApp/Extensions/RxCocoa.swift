import RxCocoa
import RxGesture
import RxSwift

extension Reactive where Base: UIView {
    func tapView(configuration: TapConfiguration? = nil) -> Signal<Void> {
        self.base.rx
            .tapGesture(configuration: configuration)
            .when(.recognized)
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
    }
}
