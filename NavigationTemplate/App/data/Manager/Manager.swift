import Foundation
import RxCocoa
import RxSwift
import RxFlow

protocol ManagerType {
    associatedtype RepositoryT
}

class Manager<T: RepositoryType>: ManagerType {
    typealias RepositoryT = T
    private let repository: RepositoryT

    let save: AnyObserver<RepositoryT.Element>
    private let onSave: Observable<RepositoryT.Element>

    let onElements: Observable<[RepositoryT.Element]>
    private let elements: AnyObserver<[RepositoryT.Element]>
    
    let refresh: AnyObserver<Void>
    private let onRefresh: Observable<Void>

    let onUploaded: Observable<Void>
    private let uploaded: AnyObserver<Void>
    
    let onLoad: Observable<Void>
    private let load: AnyObserver<Void>

    private let disposeBag = DisposeBag()

    init(repository: T) {
        self.repository = repository
        
        let elements = BehaviorSubject<[RepositoryT.Element]>(value: self.repository.elements)
        self.elements = elements.asObserver()
        self.onElements = elements.asObservable()

        let refresh = PublishSubject<Void>()
        self.refresh = refresh.asObserver()
        self.onRefresh = refresh.asObservable()
        
        let save = PublishSubject<RepositoryT.Element>()
        self.save = save.asObserver()
        self.onSave = save.asObservable()
        
        let uploaded = PublishSubject<Void>()
        self.uploaded = uploaded.asObserver()
        self.onUploaded = uploaded.asObservable()

        let load = PublishSubject<Void>()
        self.load = load.asObserver()
        self.onLoad = load.asObservable()

        setupBindings()
    }

    var first: RepositoryT.Element? {
        repository.elements.first
    }

    func remove(at index: Int) {
        repository.remove(at: index)
    }
}

extension Manager {
    private func setupBindings() {
        onRefresh
            .subscribe(onNext: {[weak self] _ in self?.repository.refresh() })
            .disposed(by: disposeBag)
        
        onSave
            .subscribe(onNext: {[weak self] in self?.repository.add($0) })
            .disposed(by: disposeBag)

        repository.onUpdate
            .map({ [weak self] _ in self?.repository.elements ?? [] })
            .bind(to: elements)
            .disposed(by: disposeBag)
        
        repository.onUploaded
            .bind(to: uploaded)
            .disposed(by: disposeBag)
        
        repository.onLoad
            .bind(to: load)
            .disposed(by: disposeBag)

    }
}
