import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class DetailMainViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()
    
    var detailView: DetailMainViewType!
    var barViewController: DetailBarViewController!

    private let disposeBag = DisposeBag()

    func configure() {
        view.backgroundColor = .white

        configureBarView()
        configureView()
        
        setupViewModelBindings()
        setupViewBindings()
    }
}

//MARK: UI
private extension DetailMainViewController {
    func configureBarView() {
        view.addSubview(barViewController.view)
        barViewController.detailBarView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
    
    func configureView() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { maker in
            maker.top.equalTo(barViewController.view.snp_bottomMargin)
            maker.trailing.leading.bottom.equalToSuperview()
        }
    }
}

//MARK: Bindings
private extension DetailMainViewController {
    func setupViewModelBindings() {
        
    }
    
    func setupViewBindings() {

    }
}


