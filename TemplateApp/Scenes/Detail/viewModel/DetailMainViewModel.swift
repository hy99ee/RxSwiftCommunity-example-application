import RxCocoa
import RxSwift

protocol DetailMainViewModelType {
    var onTitleLabel: Driver<String> { get }
    var onAgeLabel: Driver<String> { get }
    var onIdLabel: Driver<String> { get }
}

class DetailMainViewModel: DetailMainViewModelType {
    private let user: User
    let onTitleLabel: Driver<String>
    private let titleLabel: BehaviorRelay<String>
    
    let onAgeLabel: Driver<String>
    private let ageLabel: BehaviorRelay<String>
    
    let onIdLabel: Driver<String>
    private let idLabel: BehaviorRelay<String>

    init(user: User) {
        self.user = user

        titleLabel = BehaviorRelay(value: String("Name: \(user.name)"))
        onTitleLabel = titleLabel.asDriver()
        
        ageLabel = BehaviorRelay(value: String("Age = \(user.age)"))
        onAgeLabel = ageLabel.asDriver()
        
        idLabel = BehaviorRelay(value: String("ID = \(user.id)"))
        onIdLabel = idLabel.asDriver()
    }
}
