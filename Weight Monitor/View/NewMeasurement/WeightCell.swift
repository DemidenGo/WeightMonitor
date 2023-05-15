//
//  WeightValueCell.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 08.05.2023.
//

import UIKit

final class WeightCell: UITableViewCell {

    weak var delegate: WeightCellDelegate?

    private lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .labelTextColor
        textField.keyboardType = .decimalPad
        let placeholderText = NSLocalizedString("enterWeightPlaceholder",
                                                comment: "Placeholder in weightTextField")
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        textField.addTarget(self, action: #selector(textEnteringAction), for: .editingChanged)
        return textField
    }()

    private lazy var weightMeasureUnitLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 22)))
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor.withAlphaComponent(0.4)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func textEnteringAction() {
        delegate?.didEnter(weight: weightTextField.text ?? "")
    }

    private func setupConstraints() {
        contentView.addSubview(weightTextField)
        NSLayoutConstraint.activate([
            weightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            weightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            weightTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setupCell() {
        accessoryView = weightMeasureUnitLabel
        selectionStyle = .none
    }

    func set(_ weight: String, _ weightMeasure: String) {
        weightTextField.text = weight
        weightMeasureUnitLabel.text = weightMeasure
    }
}
