import RxSwift

protocol HomeViewTableViewModelType: RefreshHandlerType {}

class HomeViewTableViewModel: HomeViewTableViewModelType {
    var refreshTransaction: RefreshTransaction
    var loadTransaction: LoadTransaction
    
    init(handler refreshHandler: TableViewHandler) {
        self.loadTransaction = refreshHandler.loadTransaction
        self.refreshTransaction = refreshHandler.refreshTransaction
    }
}
