import RxSwift

typealias LoadTransaction = (onElements: Observable<[User]>, onIsLoad: Observable<Bool>)
protocol LoadHandlerType {
    var loadTransaction: LoadTransaction { get }
}

typealias SaveTransaction = (save: AnyObserver<User>, onIsLoad: Observable<Bool>)
protocol SaveHandlerType {
    var saveTransaction: SaveTransaction { get }
}

typealias RefreshTransaction = (refresh: AnyObserver<Void>, onIsLoad: Observable<Bool>)
protocol RefreshHandlerType: LoadHandlerType {
    var refreshTransaction: RefreshTransaction { get }
}
class TableViewHandler: RefreshHandlerType {
    let refreshTransaction: RefreshTransaction
    let loadTransaction: LoadTransaction
    init(
        load loadTransaction: LoadTransaction,
        refresh refreshTransaction: RefreshTransaction
    ) {
        self.loadTransaction = loadTransaction
        self.refreshTransaction = refreshTransaction
    }
}
