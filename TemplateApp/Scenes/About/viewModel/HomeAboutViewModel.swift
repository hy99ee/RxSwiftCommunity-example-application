import RxCocoa
import RxFlow
import RxSwift

class HomeAboutViewModel {
    let mover: AnyObserver<Void>
    private let onMover: Observable<Void>

    private let stepper: AnyObserver<Step>
    let onStepper: Observable<Step>

    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>

    let disposeBag = DisposeBag()

    init() {
        let moverSubj = PublishSubject<Void>()
        mover = moverSubj.asObserver()
        onMover = moverSubj.asObservable()

        let stepperSubj = PublishSubject<Step>()
        stepper = stepperSubj.asObserver()
        onStepper = stepperSubj.asObservable()

        loader = BehaviorRelay(value: true)
        onLoader = loader.asDriver()

        setupBindings()
    }

    private func createStep() -> Driver<Step> {
        Driver
            .just(HomeStep.toSettings)
            .delay(.seconds(1))
    }
}

// MARK: Bindings
extension HomeAboutViewModel {
    private func setupBindings() {
        onMover
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(stepper)
            .disposed(by: disposeBag)
    }
}
