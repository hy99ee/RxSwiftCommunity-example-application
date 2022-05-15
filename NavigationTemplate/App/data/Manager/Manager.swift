import Foundation
import RxFlow

protocol ManagerType {
    associatedtype RepositoryT
}

class Manager<T: RepositoryType>: ManagerType {
    typealias RepositoryT = T

    let repository: RepositoryT
    
    init(repository: T) {
        self.repository = repository
    }
    
    var first: RepositoryT.Element? {
        repository.elements()?.first
    }

    func add(_ element: RepositoryT.Element) -> FlowContributors {
        repository.add(element)
        
        print(repository.elements()!)

        return .none
    }

    func remove(at index: Int) {
        repository.remove(at: index)
    }
    
    func elements() -> [RepositoryT.Element]? {
        repository.elements()
    }
}
