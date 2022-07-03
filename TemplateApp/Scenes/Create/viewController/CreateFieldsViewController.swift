import RxCocoa
import RxSwift

final class FormViewController: UITableViewController {
    
    // MARK: Creating a Form View
    
    var viewModel: CreateFieldsViewModelType!
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Managing the View
    
    private enum ReuseIdentifiers: String {
        case textInput
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.textInput.rawValue)
    }
    
    // MARK: Providing Table View Content
    private func model(at indexPath: IndexPath) -> FormItem {
        viewModel.model.sections[indexPath.section].items[indexPath.item]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.model.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.model.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = model(at: indexPath)
        if let formItem = object as? TextInputFormItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.textInput.rawValue, for: indexPath) as! TextInputTableViewCell

            return cell.configured(with: formItem)
        }
        else {
            fatalError("Unknown model \(object).")
        }
    }
}


////MARK: Configure UI
//private extension CreateFieldsViewController {
//    func configureView() {
//        self.view.backgroundColor = .white
//        configureTextFields()
//    }
//    
//    func configureTextFields() {
////        view.addSubview(titleField)
////        titleField.snp.makeConstraints { maker in
////            maker.centerY.centerX.equalToSuperview()
////            maker.width.equalToSuperview()
////        }
//    }
//}
//
////MARK: Bindings
//private extension CreateFieldsViewController {
//    func setupBindings() {
//        
//    }
//}
