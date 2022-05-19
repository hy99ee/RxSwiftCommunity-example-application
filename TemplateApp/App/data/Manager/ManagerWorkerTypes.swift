import RxSwift


typealias LoadTransaction = (onElements: Observable<[User]>, onIsLoad: Observable<Bool>)
protocol ManagerLoaderType{
    var loadTransaction: LoadTransaction { get }
}

typealias SaveTransaction = (save: AnyObserver<User>, onIsLoad: Observable<Bool>)
protocol ManagerSaverType {
    var saveTransaction: SaveTransaction { get }
}

typealias RefreshTransaction = (refresh: AnyObserver<Void>, onIsLoad: Observable<Bool>)
protocol ManagerRefreshType {
    var refreshTransaction: RefreshTransaction { get }
}
