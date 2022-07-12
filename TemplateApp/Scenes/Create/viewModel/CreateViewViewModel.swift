import RxCocoa
import RxFlow
import RxSwift

protocol CreateViewViewModelType: LoadableViewModel, ClosableViewModel, CloserViewModel, SaveHandlerType, UserSelecterViewModel {
    var tapCreate: AnyObserver<Void> { get }
}

class CreateViewViewModel: CreateViewViewModelType {
    let user: AnyObserver<User>
    private let onUser: Observable<User>
    
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
        
        let user = PublishSubject<User>()
        self.user = user.asObserver()
        self.onUser = user.asObservable()

        setupBindings()
    }
}

//MARK: Bindings
extension CreateViewViewModel {
    private func setupBindings() {
        onUser
            .bind(to: saveTransaction.save)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .bind(to: loader)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .filter({ !$0 })
            .map { _ -> Void in }
            .bind(to: close)
            .disposed(by: disposeBag)
    }
}
