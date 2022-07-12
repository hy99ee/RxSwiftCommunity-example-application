import RxCocoa
import RxSwift
import RxFlow


protocol CreateAcceptViewModelType: StepableViewModel, CloserViewModel {}

class CreateAcceptViewModel: CreateAcceptViewModelType {
    let close: PublishRelay<Void>
    private let onClose: Signal<Void>

    private let stepper: AnyObserver<Step>
    let onStepper: Observable<Step>

    let disposeBag = DisposeBag()

    init() {
        let stepper = PublishSubject<Step>()
        self.stepper = stepper.asObserver()
        self.onStepper = stepper.asObservable()

        self.close = PublishRelay()
        self.onClose = close.asSignal()

        setupBindings()
    }
}

//MARK: Bindings
extension CreateAcceptViewModel {
    private func setupBindings() {
        onClose
            .map({ _ -> Step in CreateStep.close })
            .emit(to: stepper)
            .disposed(by: disposeBag)
    }
}
