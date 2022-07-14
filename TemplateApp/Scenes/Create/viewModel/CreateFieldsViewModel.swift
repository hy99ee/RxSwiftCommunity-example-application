import RxSwift
import RxCocoa
import RxFlow

protocol CreateFieldsViewModelType {
    var onUser: Driver<User?> { get }
    var model: Form! { get }
}

extension Observable where Element == String {
    func checkWithCondition(_ condition: @escaping (Element) -> Bool  = { !$0.isEmpty } ) -> Observable<Element?> {
        self.map { condition($0) ? $0 : nil }
    }
}

class CreateFieldsViewModel: CreateFieldsViewModelType {
    var model: Form!

    let onUser: Driver<User?>
    private let user: BehaviorRelay<User?>
    
    private let nameText: PublishSubject<String>
    private let descriptionText: PublishSubject<String>
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.user = BehaviorRelay(value: nil)
        self.onUser = self.user.asDriver()

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
        Observable.combineLatest(
            nameText.checkWithCondition(),
            descriptionText.checkWithCondition()
        )
        .map { element -> User? in
            guard
                let name = element.0,
                let description = element.1
            else { return nil }
            return User(id: 1, name: name, description: description, age: 0)
        }
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
