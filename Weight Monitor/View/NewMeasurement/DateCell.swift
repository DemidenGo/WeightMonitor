//
//  DateTitleTableViewCell.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 08.05.2023.
//

import UIKit

final class DateCell: UITableViewCell {

    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("dateTitle", comment: "Date title")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor
        return label
    }()

    private lazy var currentDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .interfacePurple
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
        [dateTitleLabel, currentDateLabel, chevronImageView].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            dateTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.5),
            dateTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            currentDateLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -15),
            currentDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func set(_ currentDate: String) {
        currentDateLabel.text = currentDate
    }
}
