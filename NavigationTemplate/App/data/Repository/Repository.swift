protocol RepositoryType{
    associatedtype Element

    
    func add(_ item: Element)
    func remove(at: Int)
    func elements() -> [Element]?
}

class Repository<Element>: RepositoryType {
    typealias Element = Element
    
    var _elements: [Element]?
    
    func add(_ element: Element) {
        _elements?.append(element)
    }
    
    func remove(at index: Int) {
        _elements?.remove(at: index)
    }
    
    func elements() -> [Element]? {
        _elements
    }
}
