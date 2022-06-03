import UIKit
import RxFlow
import RxSwift
import RxCocoa
import SnapKit

final class DetailMainViewController: UIViewController, Stepper {

    let steps = PublishRelay<Step>()
    
    var detailView: DetailMainViewType!

    private let disposeBag = DisposeBag()

    func configure() {
        configureView()
        
        setupViewModelBindings()
        setupViewBindings()
    }
}

//MARK: UI
private extension DetailMainViewController {
    func configureView() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

//MARK: Bindings
private extension DetailMainViewController {
    func setupViewModelBindings() {
        
    }
    
    func setupViewBindings() {

    }
}


