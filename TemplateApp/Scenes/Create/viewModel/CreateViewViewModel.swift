import RxCocoa
import RxFlow
import RxSwift

protocol CreateViewViewModelType: LoadableViewModel, ClosableViewModel, CloserViewModel, SaveHandlerType {
    var tapCreate: AnyObserver<Void> { get }
}

class CreateViewViewModel: CreateViewViewModelType {
    let tapCreate: AnyObserver<Void>
    private let onTapCreate: Observable<Void>

    let close: PublishRelay<Void>
    let onClose: Signal<Void>
    
    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>
    
    let saveTransaction: SaveTransaction
    
    let disposeBag = DisposeBag()
    
    init(save saveTransaction: SaveTransaction) {
        self.saveTransaction = saveTransaction

        let create = PublishSubject<Void>()
        self.tapCreate = create.asObserver()
        self.onTapCreate = create.asObservable()

        self.close = PublishRelay()
        self.onClose = close.asSignal()

        self.loader = BehaviorRelay(value: true)
        self.onLoader = loader.asDriver()

        setupBindings()
    }
}

//MARK: Validate and save
extension CreateViewViewModel {
    private func saveUser() -> Single<User> {
        Single
            .just(User.init(id: 111, name: "RX TEMPLATE", age: 100))
    }
}


//MARK: Bindings
extension CreateViewViewModel {
    private func setupBindings() {
        onTapCreate
            .flatMap { [unowned self] in self.saveUser() }
            .bind(to: saveTransaction.save)
            .disposed(by: disposeBag)

        onTapCreate
            .map { false }
            .bind(to: loader)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .filter({ !$0 })
            .map { _ -> Void in }
            .bind(to: close)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .map { _ in true }
            .bind(to: loader)
            .disposed(by: disposeBag)
    }
}
