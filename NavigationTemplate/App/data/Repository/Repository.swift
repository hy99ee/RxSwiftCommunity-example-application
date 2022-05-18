import RxSwift

protocol RepositoryType{
    associatedtype Element
    
    func add(_ item: Element)
    func remove(at: Int)
    func refresh()
    
    var elements: [Element] { get }

    var onUpdate: Observable<Void> { get }
    var onUploaded: Observable<Void> { get }
    var onLoad: Observable<Void> { get }
}

class Repository<Element>: RepositoryType {
    typealias Element = Element

    let onUpdate: Observable<Void>
    private let update: AnyObserver<Void>
    
    let onUploaded: Observable<Void>
    private let uploaded: AnyObserver<Void>
    
    let onLoad: Observable<Void>
    private let load: AnyObserver<Void>

    var elements: [Element] {
        didSet {
            update.onNext(())
        }
    }

    init() {
        let update = PublishSubject<Void>()
        self.update = update.asObserver()
        self.onUpdate = update.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)

        let uploaded = PublishSubject<Void>()
        self.uploaded = uploaded.asObserver()
        self.onUploaded = uploaded.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)

        let load = PublishSubject<Void>()
        self.load = load.asObserver()
        self.onLoad = load.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)

        elements = []
    }

    func add(_ element: Element) {
        load.onNext(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.elements.append(element)
            self.uploaded.onNext(())
        }
    }
    
    func remove(at index: Int) {
        load.onNext(())
        if(elements.count > index) {
            elements.remove(at: index)
            uploaded.onNext(())
        }
    }
    
    func refresh() {
        load.onNext(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            guard let self = self else { return }
            let elements = self.elements
            self.elements = elements
            self.uploaded.onNext(())
        }
    }
}
