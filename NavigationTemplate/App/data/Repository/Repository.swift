import RxSwift

protocol RepositoryType{
    associatedtype Element
    
    func add(_ item: Element)
    func remove(at: Int)
    func elements() -> [Element]?
    
    var onUpdate: Observable<Void> { get }
}

class Repository<Element>: RepositoryType {
    let onUpdate: Observable<Void>
    private let update: AnyObserver<Void>
    
    init() {
        let update = PublishSubject<Void>()
        self.update = update.asObserver()
        self.onUpdate = update.asObservable().throttle(.seconds(3), scheduler: MainScheduler.instance).debug("-----------")
        
        update.onNext(())
    }
    
    typealias Element = Element

    var _elements: [Element]?

    func add(_ element: Element) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self._elements?.append(element)
            self.update.onNext(())
        }
    }
    
    func remove(at index: Int) {
        _elements?.remove(at: index)
        update.onNext(())
    }
    
    func elements() -> [Element]? {
        _elements
    }
}
