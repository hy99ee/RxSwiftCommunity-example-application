import RxSwift

protocol HomeViewTableViewModelType: RefreshHandlerType, UserSelecterViewModel, SelectableViewModel {}

class HomeViewTableViewModel: HomeViewTableViewModelType {
    let onSelected: Observable<User>
    let user: AnyObserver<User>

    var refreshTransaction: RefreshTransaction
    var loadTransaction: LoadTransaction
    
    init(handler refreshHandler: TableViewHandler) {
        self.loadTransaction = refreshHandler.loadTransaction
        self.refreshTransaction = refreshHandler.refreshTransaction
        
        let selected = PublishSubject<User>()
        self.user = selected.asObserver()
        self.onSelected = selected.asObservable()
    }
}
