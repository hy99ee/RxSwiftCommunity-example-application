import RxCocoa
import RxSwift
import RxFlow

protocol HomeViewModelType: StepableViewModel, LoadableViewModel, NextTapperViewModel, CreateTapperViewModel, UserSelecterViewModel, CloserViewModel {
    var tapAbout: AnyObserver<Void> { get }
}

class HomeViewModel: HomeViewModelType {
    let selected: AnyObserver<User>
    private let onSelected: Observable<User>
    
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
    
    let close: PublishRelay<Void>

    let disposeBag = DisposeBag()

    init() {
        let transition = PublishSubject<Step>()
        self.transition = transition.asObserver()
        self.onTransition = transition.asObservable()
        
        let selected = PublishSubject<User>()
        self.selected = selected.asObserver()
        self.onSelected = selected.asObservable()
        
        let next = PublishSubject<Void>()
        self.tapNext = next.asObserver()
        self.onTapNext = next.asObservable()

        let about = PublishSubject<Void>()
        self.tapAbout = about.asObserver()
        self.onTapAbout = about.asObservable()
        
        let create = PublishSubject<Void>()
        self.tapCreate = create.asObserver()
        self.onTapCreate = create.asObservable()
        
        close = PublishRelay()

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
        onSelected
            .map ({ user -> Step in return HomeStep.toUser(user: user) })
            .bind(to: transition)
            .disposed(by: disposeBag)
        
        close
            .map({ _ -> Step in HomeStep.toCloseUser })
            .bind(to: transition)
            .disposed(by: disposeBag)
        
        onTapNext
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createNextStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: transition)
            .disposed(by: disposeBag)

        onTapAbout
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.createAboutStep() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: transition)
            .disposed(by: disposeBag)
                
        onTapCreate
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .map { HomeStep.toCreate }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: transition)
            .disposed(by: disposeBag)
                

    }
}
