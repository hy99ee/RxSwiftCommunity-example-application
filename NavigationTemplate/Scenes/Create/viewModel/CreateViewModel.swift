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
    
    let disposeBag = DisposeBag()
    
    init() {
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

    private func requestUser() -> Single<Step> {
        Single
            .just(CreateStep.create(user: User.init(id: 88, name: "Example", age: 00)))
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .do(onSuccess: { [weak self] _ in self?.close.onNext(()) })

//        request
//            .map({ _ -> Void in })
////            .asObservable()
//            .subscribe(close)
//            .disposed(by: disposeBag)

//        return request
    }
}

//MARK: Bindings
extension CreateViewModel {
    private func setupBindings() {
        onTapCreate
            .do(onNext: { [weak self] in self?.loader.accept(false) })
            .flatMap { [unowned self] in self.requestUser() }
            .do(onNext: { [weak self] _ in self?.loader.accept(true) })
            .bind(to: transition)
            .disposed(by: disposeBag)
                
        onClose
            .map { _ -> Step in CreateStep.close }
            .bind(to: transition)
            .disposed(by: disposeBag)
    }
}
