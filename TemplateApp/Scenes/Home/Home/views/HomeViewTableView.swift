import UIKit
import RxSwift

class HomeViewTableView: UITableView {
    var viewModel: ManagerRefreshType!
    
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
            .bind(to:self.viewModel.refreshTransaction.refresh)
            .disposed(by: disposeBag)

        viewModel.refreshTransaction.onIsLoad
            .bind(to: pullToRefresh.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        
    }
}
