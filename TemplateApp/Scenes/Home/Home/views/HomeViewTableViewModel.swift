import RxSwift

protocol HomeViewTableViewModelType: RefreshHandlerType, UserViewModel, OnUserViewModel {}

class HomeViewTableViewModel: HomeViewTableViewModelType {
    let onUser: Observable<User>
    let user: AnyObserver<User>

    var refreshTransaction: RefreshTransaction
    var loadTransaction: LoadTransaction
    
    init(handler refreshHandler: TableViewHandler) {
        self.loadTransaction = refreshHandler.loadTransaction
        self.refreshTransaction = refreshHandler.refreshTransaction
        
        let selected = PublishSubject<User>()
        self.user = selected.asObserver()
        self.onUser = selected.asObservable()
    }
}
