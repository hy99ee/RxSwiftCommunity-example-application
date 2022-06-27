import RxCocoa
import RxSwift
import RxFlow

protocol SettingsViewModelType: StepableViewModel, LoadableViewModel, NextTapperViewModel {}

class SettingsViewModel: SettingsViewModelType {
    var user: User?

    let tapNext: AnyObserver<Void>
    private let onTapNext: Observable<Void>

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

        let next = PublishSubject<Void>()
        self.tapNext = next.asObserver()
        self.onTapNext = next.asObservable()

        loader = BehaviorRelay(value: true)
        onLoader = loader.asDriver()

        setupBindings()
    }
    
    private func requestUser() -> Single<Step> {
        user = User(
            id: Int.random(in: ClosedRange(uncheckedBounds: (lower: 0, upper: 100))),
            name: "emaN",
            description: "WeWE",
            age: 99
        )

        return Single
            .just(SettingsStep.start(user: user))
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}

//MARK: Bindings
extension SettingsViewModel {
    private func setupBindings() {
        onTapNext
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.requestUser() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(stepper)
            .disposed(by: disposeBag)
    }
}
