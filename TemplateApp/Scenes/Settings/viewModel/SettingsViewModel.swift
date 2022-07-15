import RxCocoa
import RxFlow
import RxSwift

protocol SettingsViewModelType: StepableViewModel, OnLoadViewModel, NextTapperViewModel {}

class SettingsViewModel: SettingsViewModelType {
    var user: User?

    let tapNext: PublishRelay<Void>
    private let onTapNext: Signal<Void>

    private let stepper: AnyObserver<Step>
    let onStepper: Observable<Step>

    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>

    let disposeBag = DisposeBag()

    init(user: User?) {
        self.user = user

        let stepper = PublishSubject<Step>()
        self.stepper = stepper.asObserver()
        self.onStepper = stepper.asObservable()

        self.tapNext = PublishRelay()
        self.onTapNext = tapNext.asSignal()

        loader = BehaviorRelay(value: true)
        onLoader = loader.asDriver()

        setupBindings()
    }

    private func requestUser() -> Signal<Step> {
        user = User(
            id: Int.random(in: ClosedRange(uncheckedBounds: (lower: 0, upper: 100))),
            name: "emaN",
            description: "WeWE",
            age: 99
        )

        return Signal
            .just(SettingsStep.start(user: user))
            .delay(.seconds(1))
    }
}

// MARK: Bindings
extension SettingsViewModel {
    private func setupBindings() {
        onTapNext
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.requestUser() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .emit(to: stepper)
            .disposed(by: disposeBag)
    }
}
