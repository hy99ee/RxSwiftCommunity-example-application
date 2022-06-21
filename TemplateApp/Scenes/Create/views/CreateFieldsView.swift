import RxCocoa
import RxSwift

class CreateFieldsView: UIView {
    var viewModel: CreateFieldsViewModelType!
    
    func configured() -> Self {
        configureView()
        setupBindings()
        
        return self
    }
}

//MARK: Configure UI
private extension CreateFieldsView {
    func configureView() {
//        backgroundColor = .green
    }
}

//MARK: Bindings
private extension CreateFieldsView {
    func setupBindings() {
        
    }
}
