import RxSwift

protocol RepositoryType{
    associatedtype Element
    
    func add(_ item: Element)
    func remove(at: Int)
    func refresh()
    
    var elements: [Element] { get }

    var onUpdate: Observable<Void> { get }
    var onIsLoad: Observable<Bool> { get }
}

class Repository<Element>: RepositoryType {
    typealias Element = Element

    let onUpdate: Observable<Void>
    private let update: AnyObserver<Void>
    
    let onIsLoad: Observable<Bool>
    private let isLoad: AnyObserver<Bool>

    var elements: [Element] = [] {
        didSet {
            update.onNext(())
        }
    }

    init() {
        let update = PublishSubject<Void>()
        self.update = update.asObserver()
        self.onUpdate = update.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)

        let isLoad = PublishSubject<Bool>()
        self.isLoad = isLoad.asObserver()
        self.onIsLoad = isLoad.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)

        elements = []
    }

    func add(_ element: Element) {
        isLoad.onNext(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.elements.append(element)
            self.isLoad.onNext(false)
        }
    }

    func remove(at index: Int) {
        isLoad.onNext(true)
        if(elements.count > index) {
            elements.remove(at: index)
            isLoad.onNext(false)
        }
    }

    func refresh() {
        isLoad.onNext(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {[weak self] in
            guard let self = self else { return }
            let elements = self.elements
            self.elements = elements
            self.isLoad.onNext(false)
        }
    }
}
