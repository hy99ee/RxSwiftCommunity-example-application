import RxCocoa
import RxSwift

class AppRepository: Repository<User> {
    override init() {
        super.init()

        _elements = [
            User.create(),
            User.init(id: 10, name: "Name", age: 99),
            User.init(id: 01, name: "emaN", age: 00)
        ]
    }
}
