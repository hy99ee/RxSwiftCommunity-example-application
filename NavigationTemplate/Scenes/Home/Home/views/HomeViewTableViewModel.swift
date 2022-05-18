import RxSwift

class HomeViewTableViewModel: ManagerRefreshType {
    let refreshTransaction: RefreshTransaction
    
    private let pullRefresh: Observable<Void>
    private let onPullRefresh: Observable<Void>

    init(refresh refreshTransaction: RefreshTransaction) {
        self.refreshTransaction = refreshTransaction
        
        let pullRefresh = PublishSubject<Void>()
        self.pullRefresh = pullRefresh.asObserver()
        self.onPullRefresh = pullRefresh.asObservable()
    }
}
