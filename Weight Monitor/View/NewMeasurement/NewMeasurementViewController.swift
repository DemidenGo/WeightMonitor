//
//  NewMeasurementViewController.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 08.05.2023.
//

import UIKit

final class NewMeasurementViewController: UIViewController {

    var viewModel: NewMeasurementViewModelProtocol?

    private let notificationCenter = NotificationCenter.default

    private var addMeasurementButtonBottomConstraint = NSLayoutConstraint()

    private lazy var dismissIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.backgroundColor = .dismissIndicatorColor
        return view
    }()

    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("newMeasurementTitle", comment: "Add new measurement screen title")
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()

    private lazy var measurementTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.identifier)
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.identifier)
        tableView.register(WeightCell.self, forCellReuseIdentifier: WeightCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var addMeasurementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .interfacePurple
        let buttonTitle = NSLocalizedString("addButtonTitle", comment: "Add measurement button title")
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addMeasurementButtonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        hideKeyboardByTap()
        setupConstraints()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private funcs

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.currentAppearanceObservable.bind { [weak self] currentAppearance in
            switch currentAppearance {
            case .datePickerIsHidden: self?.deleteDateWheels()
            case .datePickerIsVisible: self?.insertDateWheels()
            }
        }
        viewModel.currentDateObservable.bind { [weak self] _ in
            self?.updateCurrentDateLabel()
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            viewModel?.hideDatePicker()
            UIView.animate(withDuration: 1) {
                self.addMeasurementButtonBottomConstraint.constant = -(50 + keyboardSize.height)
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 1) {
            self.addMeasurementButtonBottomConstraint.constant = -50
            self.view.layoutIfNeeded()
        }
    }

    @objc private func addMeasurementButtonAction() {
        guard viewModel?.currentWeight != "" else { return }
        viewModel?.addCurrentMeasurement()
        dismiss(animated: true)
    }

    private func setupConstraints() {
        [dismissIndicatorView, screenTitleLabel, measurementTableView, addMeasurementButton].forEach { view.addSubview($0) }

        addMeasurementButtonBottomConstraint = addMeasurementButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)

        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 36),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 5),

            screenTitleLabel.topAnchor.constraint(equalTo: dismissIndicatorView.bottomAnchor, constant: 19),
            screenTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitleLabel.heightAnchor.constraint(equalToConstant: 24),

            measurementTableView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 111),
            measurementTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            measurementTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            measurementTableView.heightAnchor.constraint(equalToConstant: 342),

            addMeasurementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addMeasurementButtonBottomConstraint,
            addMeasurementButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addMeasurementButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func insertDateWheels() {
        measurementTableView.performBatchUpdates {
            measurementTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }

    private func deleteDateWheels() {
        measurementTableView.performBatchUpdates {
            measurementTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }

    private func updateCurrentDateLabel() {
        measurementTableView.performBatchUpdates {
            measurementTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate

extension NewMeasurementViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel?.height(for: indexPath.row) ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel?.didTapDate()
        }
    }
}

// MARK: - UITableViewDataSource

extension NewMeasurementViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dateCell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier) as? DateCell,
              let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.identifier) as? DatePickerCell,
              let weightCell = tableView.dequeueReusableCell(withIdentifier: WeightCell.identifier) as? WeightCell,
              let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(for: indexPath.row)
        dateCell.set(viewModel.dateStringForCurrentDate)
        weightCell.set(viewModel.currentWeight, viewModel.weightMeasureString)
        datePickerCell.delegate = self
        weightCell.delegate = self
        switch cellViewModel.id {
        case .date: return dateCell
        case .datePicker: return datePickerCell
        case .weight: return weightCell
        }
    }
}

// MARK: - DatePickerCellDelegate

extension NewMeasurementViewController: DatePickerCellDelegate {

    func dateChanged(_ newDate: Date) {
        viewModel?.dateChanged(newDate)
    }
}

// MARK: - WeightCellDelegate

extension NewMeasurementViewController: WeightCellDelegate {

    func didEnter(weight: String) {
        viewModel?.weightChanged(weight)
    }
}
