import RxCocoa
import RxSwift
import RxFlow

protocol CreateViewModelType: StepableViewModel, LoadableViewModel, CreateTapperViewModel {}

class CreateViewModel: CreateViewModelType, SaveHandlerType {
    let tapCreate: AnyObserver<Void>
    private let onTapCreate: Observable<Void>
    
    private let close: AnyObserver<Void>
    private let onClose: Observable<Void>

    private let transition: AnyObserver<Step>
    let onTransition: Observable<Step>
    
    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>
    
    let saveTransaction: SaveTransaction
    
    let disposeBag = DisposeBag()
    
    init(save saveTransaction: SaveTransaction) {
        self.saveTransaction = saveTransaction
        
        let transition = PublishSubject<Step>()
        self.transition = transition.asObserver()
        self.onTransition = transition.asObservable()

        let create = PublishSubject<Void>()
        self.tapCreate = create.asObserver()
        self.onTapCreate = create.asObservable()

        let close = PublishSubject<Void>()
        self.close = close.asObserver()
        self.onClose = close.asObservable()

        loader = BehaviorRelay(value: true)
        onLoader = loader.asDriver()

        setupBindings()
    }

    private func saveUser() -> Single<User> {
        Single
            .just(User.init(id: 111, name: "RX TEMPLATE", age: 100))
    }
}

//MARK: Bindings
extension CreateViewModel {
    private func setupBindings() {
        onTapCreate
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.saveUser() }
            .bind(to: saveTransaction.save)
            .disposed(by: disposeBag)
        
//        onTapCreate
//            .map { _ -> Step in CreateStep.close }
//            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
//            .bind(to: transition)
//            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .filter({ !$0 })
            .map { _ -> Step in CreateStep.close }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: transition)
            .disposed(by: disposeBag)
    }
}
