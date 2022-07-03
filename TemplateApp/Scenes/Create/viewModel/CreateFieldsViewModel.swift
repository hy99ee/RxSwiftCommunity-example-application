import RxSwift
import RxCocoa
import RxFlow

protocol CreateFieldsViewModelType {
    var onUser: Observable<User> { get }
    var onIsValidUser: Driver<Bool> { get }
    var model: Form! { get }
}

//class TextValidator {
//    var input: Observable<String>
//    var condition: (String) -> Bool
//
//    init(input: Observable<String>, condition: @escaping (String) -> Bool) {
//       self.input = input
//       self.condition = condition
//    }
//
//    func validate() -> Observable<Bool> {
//        return input.map {[weak self] in self?.condition($0) ?? false }
//    }
//}

extension Observable where Element == String {
    func validateString(condition: @escaping (String) -> Bool = { !$0.isEmpty }) -> Observable<Bool> {
        self.map { condition($0) }
    }
}

class CreateFieldsViewModel: CreateFieldsViewModelType {
    var model: Form!
    
    let onIsValidUser: Driver<Bool>
    private let isValidUser: BehaviorRelay<Bool>

    let onUser: Observable<User>
    private let user: AnyObserver<User>
    
    private let nameText: PublishSubject<String>
    private let descriptionText: PublishSubject<String>
    
    private let disposeBag = DisposeBag()
    
    init() {
        let user = PublishSubject<User>()
        self.user = user.asObserver()
        self.onUser = user.asObservable()
        
        self.isValidUser = BehaviorRelay(value: false)
        self.onIsValidUser = isValidUser.asDriver()
        

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
    
//    private let validateFields: Observable<Bool> = {
//
//        return .just(false)
//    }()
}

private extension CreateFieldsViewModel {
    func setupBindings() {
//        Observable.combineLatest(nameText, descriptionText)
//            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
//            .filter { $0 != "" && $1 != "" }
//            .map{ _ in false }
//            .bind(to: isValidUser)
//            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(
            nameText.validateString(),
            descriptionText.validateString())
//            TextValidator(input: nameText, condition: { !$0.isEmpty } ).validate(),
//            TextValidator(input: descriptionText, condition: { !$0.isEmpty } ).validate())
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0 && $1 ? true : false }
            .bind(to: isValidUser)
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
