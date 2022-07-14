import RxCocoa
import RxFlow
import RxSwift

protocol CreateViewViewModelType: UserViewModel, OnUserViewModel, NextTapperViewModel {}

class CreateViewViewModel: CreateViewViewModelType {
    let user: AnyObserver<User>
    let onUser: Observable<User>
    
    let tapNext: PublishRelay<Void>
    let onTapNext: Signal<Void>

    let close: PublishRelay<Void>
    let onClose: Signal<Void>

    let disposeBag = DisposeBag()

    init() {
        self.tapNext = PublishRelay()
        self.onTapNext = tapNext.asSignal()

        self.close = PublishRelay()
        self.onClose = close.asSignal()

        let user = PublishSubject<User>()
        self.user = user.asObserver()
        self.onUser = user.asObservable()

        setupBindings()
    }
}

// MARK: Bindings
extension CreateViewViewModel {
    private func setupBindings() {
//        onUser
//            .bind(to: user)
//            .disposed(by: disposeBag)

//        onUser
//            .bind(to: saveTransaction.save)
//            .disposed(by: disposeBag)

//        saveTransaction.onIsLoad
//            .bind(to: loader)
//            .disposed(by: disposeBag)

//        saveTransaction.onIsLoad
//            .filter({ !$0 })
//            .map { _ -> Void in }
//            .bind(to: close)
//            .disposed(by: disposeBag)
    }
}
