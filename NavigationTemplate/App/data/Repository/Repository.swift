import RxSwift

protocol RepositoryType{
    associatedtype Element
    
    func add(_ item: Element)
    func remove(at: Int)
    func elements() -> [Element]
    
    var onUpdate: Observable<Void> { get }
}

class Repository<Element>: RepositoryType {
    typealias Element = Element

    let onUpdate: Observable<Void>
    private let update: AnyObserver<Void>

    var _elements: [Element] {
        didSet {
            update.onNext(())
        }
    }

    init() {
        let update = PublishSubject<Void>()
        self.update = update.asObserver()
        self.onUpdate = update.asObservable().throttle(.seconds(3), scheduler: MainScheduler.instance)
        
        _elements = []
    }

    func add(_ element: Element) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self._elements.append(element)
        }
    }
    
    func remove(at index: Int) {
        if(_elements.count > index) {
            _elements.remove(at: index)
        }
    }
    
    func elements() -> [Element] {
        _elements
    }
}
