import SnapKit
import UIKit

class DetailViewTableViewCell: UITableViewCell {
    lazy var dateLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray

        return label
    }()

    lazy var titleLabel: UILabel = {
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
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: UI
private extension DetailViewTableViewCell {
    func configure() {
        backgroundColor = .white

        configureTitleLabel()
    }

    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().inset(50)
        }
    }
}
