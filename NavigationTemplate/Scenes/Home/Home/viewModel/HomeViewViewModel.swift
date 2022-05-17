import RxSwift


class HomeViewViewModel {
    let elements: Observable<[User]>
    
    init(elements: Observable<[User]>) {
        self.elements = elements
    }
}
