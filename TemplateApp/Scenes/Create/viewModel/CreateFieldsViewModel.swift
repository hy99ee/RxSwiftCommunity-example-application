import RxSwift
import RxCocoa
import RxFlow

//enum CreateFieldsData: String {
//    case Enter
//
//    var valuesBySection: [String] {
//        switch self {
//        case .Enter:
//            return [
//                "Name",
//                "Age"
//            ]
//        }
//    }
//
//    var numberFromSection: Int {
//        valuesBySection.count
//    }
//}


protocol CreateFieldsViewModelType {
    var onUser: Observable<User> { get }
    var model: Form! { get }
}

class CreateFieldsViewModel: CreateFieldsViewModelType {
    var model: Form!
    
    let onUser: Observable<User>
    private let user: AnyObserver<User>
    
    private let nameText: PublishSubject<String>
    private let descriptionText: PublishSubject<String>
    
    private let disposeBag = DisposeBag()
    
    init() {
        let user = PublishSubject<User>()
        self.user = user.asObserver()
        self.onUser = user.asObservable()

        self.nameText = PublishSubject()
        self.descriptionText = PublishSubject()
    }
    
    func configured() -> Self {
        model = Form(sections: [
            FormSection(items: [
                bindingsForName(TextInputFormItem(placeholder: "Add title")),
                bindingsForDescription(TextInputFormItem(placeholder: "Add description"))
                ])
            ])
        
        setupBindings()

        return self
    }
}

private extension CreateFieldsViewModel {
    func setupBindings() {
        Observable.combineLatest(nameText, descriptionText)
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .filter { $0 != "" && $1 != "" }
            .map{ User(id: 01, name: $0, description: $1, age: 10) }
            .debug("_________")
            .bind(to: user)
            .disposed(by: disposeBag)
    }
    
    func bindingsForName(_ item: TextInputFormItem) -> TextInputFormItem {
        item.text.asObservable()
            .distinctUntilChanged()
            .bind(to: nameText)
            .disposed(by: disposeBag)

        return item
    }
    
    func bindingsForDescription(_ item: TextInputFormItem) -> TextInputFormItem {
        item.text.asObservable()
            .distinctUntilChanged()
            .bind(to: descriptionText)
            .disposed(by: disposeBag)

        return item
    }
}
