import RxCocoa
import RxSwift
import RxFlow

class HomeAboutViewModel {
    let mover: AnyObserver<Void>
    private let onMover: Observable<Void>

    private let transition: AnyObserver<Step>
    let onTransition: Observable<Step>
    
    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>
    
    let disposeBag = DisposeBag()
    
    init() {
        let moverSubj = PublishSubject<Void>()
        mover = moverSubj.asObserver()
        onMover = moverSubj.asObservable()

        let transitionSubj = PublishSubject<Step>()
        transition = transitionSubj.asObserver()
        onTransition = transitionSubj.asObservable()

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

//MARK: Bindings
extension HomeAboutViewModel {
    private func setupBindings() {
        onMover
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(transition)
            .disposed(by: disposeBag)
    }
}
