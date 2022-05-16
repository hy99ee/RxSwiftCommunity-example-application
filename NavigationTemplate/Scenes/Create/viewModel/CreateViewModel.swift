import RxCocoa
import RxSwift
import RxFlow

class CreateViewModel {
    let tapCreate: AnyObserver<Void>
    private let onTapCreate: Observable<Void>
    
    private let close: AnyObserver<Void>
    private let onClose: Observable<Void>

    private let transition: AnyObserver<Step>
    let onTransition: Observable<Step>
    
    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>
    
    private let saveTransaction: PublishSubject<User>
    
    let disposeBag = DisposeBag()
    
    init(save saveTransaction: PublishSubject<User>) {
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
            .delay(.seconds(1), scheduler: MainScheduler.instance)
//            .do(onSuccess: { [weak self] _ in self?.close.onNext(()) })
    }
}

//MARK: Bindings
extension CreateViewModel {
    private func setupBindings() {
        onTapCreate
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.saveUser() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: saveTransaction)
            .disposed(by: disposeBag)
                
        saveTransaction
            .map { _ -> Step in CreateStep.close }
            .bind(to: transition)
            .disposed(by: disposeBag)
    }
}
