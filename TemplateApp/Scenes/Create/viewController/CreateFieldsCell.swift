import UIKit
import RxCocoa
import RxSwift

final class TextInputTableViewCell: UITableViewCell {
    private var formItem: FormItem!
    private let disposeBag = DisposeBag()
    func configured(with item: FormItem) -> Self {
        self.formItem = item

        configure()
        setupBindings()

        return self
    }
    
    lazy private var editableTextField = UITextField()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editableTextField.becomeFirstResponder()
    }
}

// MARK: UI
private extension TextInputTableViewCell {
    func configure() {
        editableTextField.textColor = .gray
        editableTextField.placeholder = formItem.placeholder
        contentView.addSubview(editableTextField)
        editableTextField.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().offset(20)
            maker.top.bottom.equalToSuperview()
        }
    }
}

// MARK: Bindings
private extension TextInputTableViewCell {
    func setupBindings() {
        editableTextField.rx.text.asObservable()
            .compactMap { $0 }
            .subscribe(formItem.text)
            .disposed(by: disposeBag)
    }
}

