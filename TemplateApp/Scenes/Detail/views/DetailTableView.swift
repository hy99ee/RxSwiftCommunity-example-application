import RxCocoa
import RxSwift

protocol DetailMainViewType where Self: UITableView {
    var viewModel: DetailMainViewModelType! { get }
}

class DetailTableView: UITableView, DetailMainViewType {
    var viewModel: DetailMainViewModelType!

    private let disposeBag = DisposeBag()

    func configured() -> Self {
        register(DetailViewTableViewCell.self, forCellReuseIdentifier: "DetailCell")

        rowHeight = 50.0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        setupBindings()

        return self
    }
}

// MARK: Bindings
private extension DetailTableView {
    func setupBindings() {
        viewModel.onUserDetail
            .drive(self.rx.items(cellIdentifier: "DetailCell", cellType: DetailViewTableViewCell.self)) { _, title, cell in
                cell.titleLabel.text = String(title)
            }
            .disposed(by: disposeBag)
    }
}
