import Foundation
import RxCocoa
import RxSwift
import RxFlow

protocol ManagerType {
    associatedtype RepositoryT
}

protocol RxManager {
    var next: PublishRelay<Any> { get }
    var onNext: Signal<Any> { get }
}

class Manager<T: RepositoryType>: ManagerType {
    typealias RepositoryT = T
    let repository: RepositoryT

    let saveTransaction: PublishSubject<RepositoryT.Element>

    let elements: BehaviorSubject<[RepositoryT.Element]?>

    private let disposeBag = DisposeBag()

    init(repository: T) {
        self.repository = repository

        saveTransaction = PublishSubject<RepositoryT.Element>()
        elements = BehaviorSubject<[RepositoryT.Element]?>(value: self.repository.elements())

        setupBindings()
    }
    
    var first: RepositoryT.Element? {
        repository.elements()?.first
    }

    func remove(at index: Int) {
        repository.remove(at: index)
    }
}

extension Manager {
    private func setupBindings() {
        saveTransaction
            .compactMap { $0 }
            .subscribe(onNext: {[weak self] in self?.repository.add($0) })
            .disposed(by: disposeBag)

        repository.onUpdate
            .map({ [weak self] _ in self?.repository.elements() })
            .bind(to: elements)
            .disposed(by: disposeBag)
    }
}
