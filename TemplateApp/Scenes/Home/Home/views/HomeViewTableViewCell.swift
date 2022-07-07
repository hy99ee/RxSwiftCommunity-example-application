import UIKit
import SnapKit

class HomeViewTableViewCell: UITableViewCell {
    let dateLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray

        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemGray

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI
private extension HomeViewTableViewCell {
    func configure() {
        backgroundColor = .white

        configureTitleLabel()
        configureDateLabel()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().inset(50)
        }
    }
    
    func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().inset(50)
        }
    }
}
