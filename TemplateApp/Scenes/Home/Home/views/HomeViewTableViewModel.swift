import RxSwift

protocol HomeViewTableViewModelType: RefreshHandlerType, SelectedViewModel, onSelectedViewModel {}

class HomeViewTableViewModel: HomeViewTableViewModelType {
    let onSelected: Observable<User>
    let selected: AnyObserver<User>

    var refreshTransaction: RefreshTransaction
    var loadTransaction: LoadTransaction
    
    init(handler refreshHandler: TableViewHandler) {
        self.loadTransaction = refreshHandler.loadTransaction
        self.refreshTransaction = refreshHandler.refreshTransaction
        
        let selected = PublishSubject<User>()
        self.selected = selected.asObserver()
        self.onSelected = selected.asObservable()
    }
}
