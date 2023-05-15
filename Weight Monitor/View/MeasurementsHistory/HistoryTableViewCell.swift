//
//  HistoryTableViewCell.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 07.05.2023.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {

    private var labelWidth: CGFloat { UIScreen.main.bounds.width / 3 - 9 }

    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor
        return label
    }()

    private lazy var changesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor.withAlphaComponent(0.6)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .labelTextColor.withAlphaComponent(0.4)
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        imageView.image = UIImage(systemName: "chevron.forward", withConfiguration: imageConfig)
        imageView.tintColor = .labelTextColor
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        [weightLabel, changesLabel, dateLabel, chevronImageView].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.widthAnchor.constraint(equalToConstant: labelWidth),

            changesLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 8),
            changesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            changesLabel.widthAnchor.constraint(equalToConstant: labelWidth),

            dateLabel.leadingAnchor.constraint(equalTo: changesLabel.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor,constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }

    func set(weight: String, weightChange: String, date: String) {
        weightLabel.text = weight
        changesLabel.text = weightChange
        dateLabel.text = date
    }
}
