import UIKit
import RxSwift

class HomeViewTableView: UITableView {
    var viewModel: HomeViewTableViewModelType!
    
    let pullToRefresh = UIRefreshControl()
    
    private let disposeBag = DisposeBag()

    func configured() -> Self {
        register(HomeViewTableViewCell.self, forCellReuseIdentifier: "HomeCell")

        translatesAutoresizingMaskIntoConstraints = false
        refreshControl = pullToRefresh

        setupBindings()

        return self
    }
}

private extension HomeViewTableView {
    func setupBindings() {
        pullToRefresh.rx.controlEvent(.valueChanged)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(to: viewModel.refreshTransaction.refresh)
            .disposed(by: disposeBag)

        viewModel.refreshTransaction.onIsLoad
            .bind(to: pullToRefresh.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.loadTransaction.onElements
            .bind(to: self.rx.items(cellIdentifier: "HomeCell", cellType: HomeViewTableViewCell.self)) { indexPath, title, cell in
                cell.titleLabel.text = title.name
                cell.dateLabel.text = String(title.age)
            }
            .disposed(by: disposeBag)
        
//        self.rx.modelSelected(User.self).subscribe(onNext: { item in
//             print("SelectedItem: \(item.name)")
//         }).disposed(by: disposeBag)

        self.rx.modelSelected(User.self).bind(to: viewModel.selected)
            .disposed(by: disposeBag)

        viewModel.loadTransaction.onIsLoad
            .filter({ !$0 })
            .map({ _ -> CGFloat in 1 })
            .bind(to: self.rx.alpha)
            .disposed(by: disposeBag)

        viewModel.loadTransaction.onIsLoad
            .filter({ $0 })
            .map({ _ -> CGFloat in 0.5 })
            .bind(to: self.rx.alpha)
            .disposed(by: disposeBag)
    }
}
