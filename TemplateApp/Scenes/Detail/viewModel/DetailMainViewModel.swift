import RxCocoa
import RxSwift

protocol DetailMainViewModelType {
    var onUserDetail: Driver<[String]> { get }
}

class DetailMainViewModel: DetailMainViewModelType {
    let onUserDetail: Driver<[String]>
//    private let userDetail: BehaviorRelay<String>
//    private var _user: User

    init(user: User) {
//        self._user = user
        self.onUserDetail = Driver.of(user.sequence()).debug("sequence")
    }
}
