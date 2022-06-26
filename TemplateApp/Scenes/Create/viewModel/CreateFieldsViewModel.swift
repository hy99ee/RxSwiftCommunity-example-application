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
    private let disposeBag = DisposeBag()
    
    init() {

        
        let user = PublishSubject<User>()
        self.user = user.asObserver()
        self.onUser = user.asObservable()
    }
    
    func configured() -> Self {
        model = Form(sections: [
            FormSection(items: [
                bindingsForName(TextInputFormItem(placeholder: "Add title")),
                TextInputFormItem(placeholder: "Add description")
                ])
            ])

        return self
    }
    
    func bindingsForName(_ item: TextInputFormItem) -> TextInputFormItem {
        item.text.asObservable()
            .map { User(id: 10, name: $0, age: 10) }
            .bind(to: user)
            .disposed(by: disposeBag)

        return item
    }
}
