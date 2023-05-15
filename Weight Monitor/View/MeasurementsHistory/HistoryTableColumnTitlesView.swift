//
//  TableHeaderView.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 07.05.2023.
//

import UIKit

final class HistoryTableColumnTitlesView: UIView {

    private var labelWidth: CGFloat { (UIScreen.main.bounds.width - 48) / 3 }

    private lazy var weightTitleLabel: UILabel = {
        let label = makeLabel()
        label.text = NSLocalizedString("weightTitle", comment: "Weight title in table")
        return label
    }()

    private lazy var changesTitleLabel: UILabel = {
        let label = makeLabel()
        label.text = NSLocalizedString("changesTitle", comment: "Weight changes title in table")
        return label
    }()

    private lazy var dateTitleLabel: UILabel = {
        let label = makeLabel()
        label.text = NSLocalizedString("dateTitle", comment: "Date title in table")
        return label
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tableHeaderLineColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelTextColor.withAlphaComponent(0.4)
        return label
    }

    private func setupConstraints() {
        [weightTitleLabel, changesTitleLabel, dateTitleLabel, lineView].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            weightTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            weightTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            weightTitleLabel.widthAnchor.constraint(equalToConstant: labelWidth + 7),

            changesTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            changesTitleLabel.leadingAnchor.constraint(equalTo: weightTitleLabel.trailingAnchor, constant: 8),
            changesTitleLabel.widthAnchor.constraint(equalToConstant: labelWidth + 7),

            dateTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            dateTitleLabel.leadingAnchor.constraint(equalTo: changesTitleLabel.trailingAnchor, constant: 8),
            dateTitleLabel.widthAnchor.constraint(equalToConstant: labelWidth - 14),

            lineView.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 8),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
