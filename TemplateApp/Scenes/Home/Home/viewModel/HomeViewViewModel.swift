import RxSwift


class HomeViewViewModel: ManagerLoaderType {
    let loadTransaction: LoadTransaction

    init(load loadTransaction: LoadTransaction) {
        self.loadTransaction = loadTransaction
    }
}
