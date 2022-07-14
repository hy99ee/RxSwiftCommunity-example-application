import RxCocoa
import RxFlow
import RxSwift

protocol CreateAcceptViewModelType: StepableViewModel, CreateTapViewModel, OnLoadViewModel {
    var onUserName: Driver<String> { get }
    var onUserDescription: Driver<String> { get }
}

class CreateAcceptViewModel: CreateAcceptViewModelType {
    private let user: User
    private let saveTransaction: SaveTransaction

    let tapCreate: PublishRelay<Void>
    private let onTapCreate: Signal<Void>

    private let stepper: AnyObserver<Step>
    let onStepper: Observable<Step>

    private let loader: BehaviorRelay<Bool>
    let onLoader: Driver<Bool>

    let onUserName: Driver<String>
    private let userName: BehaviorRelay<String>

    let onUserDescription: Driver<String>
    private let userDescription: BehaviorRelay<String>

    let disposeBag = DisposeBag()

    init(user: User, save saveTransaction: SaveTransaction) {
        self.saveTransaction = saveTransaction
        self.user = user

        let stepper = PublishSubject<Step>()
        self.stepper = stepper.asObserver()
        self.onStepper = stepper.asObservable()

        self.tapCreate = PublishRelay()
        self.onTapCreate = tapCreate.asSignal()

        self.loader = BehaviorRelay(value: false)
        self.onLoader = loader.asDriver()

        self.userName = BehaviorRelay(value: self.user.name)
        self.onUserName = userName.asDriver()

        self.userDescription = BehaviorRelay(value: self.user.description)
        self.onUserDescription = userDescription.asDriver()

        setupBindings()
    }
}

// MARK: Bindings
extension CreateAcceptViewModel {
    private func setupBindings() {
        onTapCreate
            .map { [unowned self] in self.user }
            .emit(to: saveTransaction.save)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .filter({ !$0 })
            .map({ _ -> Step in CreateStep.close })
            .bind(to: stepper)
            .disposed(by: disposeBag)

        saveTransaction.onIsLoad
            .bind(to: loader)
            .disposed(by: disposeBag)
    }
}
