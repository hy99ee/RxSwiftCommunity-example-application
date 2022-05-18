import UIKit
import RxSwift

class HomeViewTableView: UITableView {
    var viewModel: ManagerRefreshType
    
    let pullToRefresh = UIRefreshControl()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ManagerRefreshType) {
        self.viewModel = viewModel

        super.init(frame: .zero, style: .grouped)

        translatesAutoresizingMaskIntoConstraints = false
        register(HomeViewTableViewCell.self, forCellReuseIdentifier: "HomeCell")
        
        self.refreshControl = pullToRefresh
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configured() -> Self {
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
        
        viewModel.refreshTransaction.onUploaded
            .map{ false }
            .bind(to: pullToRefresh.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
