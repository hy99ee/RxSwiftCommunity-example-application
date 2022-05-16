import RxCocoa
import RxSwift
import RxFlow

class HomeViewModel {
    let tapNext: AnyObserver<Void>
    private let onTapNext: Observable<Void>

    let tapAbout: AnyObserver<Void>
    private let onTapAbout: Observable<Void>

    let tapCreate: AnyObserver<Void>
    private let onTapCreate: Observable<Void>

    private let transition: AnyObserver<Step>
    let onTransition: Observable<Step>

    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>

    let disposeBag = DisposeBag()

    init() {
        let transition = PublishSubject<Step>()
        self.transition = transition.asObserver()
        self.onTransition = transition.asObservable()
        
        let next = PublishSubject<Void>()
        self.tapNext = next.asObserver()
        self.onTapNext = next.asObservable()

        let about = PublishSubject<Void>()
        self.tapAbout = about.asObserver()
        self.onTapAbout = about.asObservable()
        
        let create = PublishSubject<Void>()
        self.tapCreate = create.asObserver()
        self.onTapCreate = create.asObservable()

        loader = BehaviorRelay(value: true)
        onLoader = loader.asDriver()

        setupBindings()
    }
    
    private func createNextStep() -> Driver<Step> {
        Driver
            .just(HomeStep.toSettings)
            .delay(.seconds(1))
    }
    
    private func createAboutStep() -> Driver<Step> {
        Driver
            .just(HomeStep.toAbout)
            .delay(.seconds(1))
    }
    
    private func createCreateStep() -> Driver<Step> {
        Driver
            .just(HomeStep.toCreate)
            .delay(.seconds(1))
    }
}

//MARK: Bindings
extension HomeViewModel {
    private func setupBindings() {
        onTapNext
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createNextStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(transition)
            .disposed(by: disposeBag)

        onTapAbout
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createAboutStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(transition)
            .disposed(by: disposeBag)
                
        onTapCreate
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .map { HomeStep.toCreate }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .subscribe(transition)
            .disposed(by: disposeBag)
    }
}
