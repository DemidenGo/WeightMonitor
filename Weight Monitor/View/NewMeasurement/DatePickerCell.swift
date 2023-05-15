//
//  DatePickerCell.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 08.05.2023.
//

import UIKit

final class DatePickerCell: UITableViewCell {

    weak var delegate: DatePickerCellDelegate?

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChangedAction), for: .valueChanged)
        return datePicker
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func dateChangedAction() {
        delegate?.dateChanged(datePicker.date)
    }

    private func setupConstraints() {
        contentView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
