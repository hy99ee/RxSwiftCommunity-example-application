import UIKit

protocol HomeAboutViewType where Self: UIView {}

class HomeAboutView: UIView, HomeAboutViewType {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 37)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .green

        configureCloseButton()
    }
    
    func configureCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview().inset(30)
            maker.height.width.equalTo(40)
        }
    }
}
