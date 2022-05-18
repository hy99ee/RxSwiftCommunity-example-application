import RxSwift


typealias LoadTransaction = (onElements: Observable<[User]>, onLoad: Observable<Void>)
protocol ManagerLoaderType{
    var loadTransaction: LoadTransaction { get }
}

typealias SaveTransaction = (save: AnyObserver<User>, onUploaded: Observable<Void>)
protocol ManagerSaverType {
    var saveTransaction: SaveTransaction { get }
}

typealias RefreshTransaction = (refresh: AnyObserver<Void>, onUploaded: Observable<Void>)
protocol ManagerRefreshType {
    var refreshTransaction: RefreshTransaction { get }
}
