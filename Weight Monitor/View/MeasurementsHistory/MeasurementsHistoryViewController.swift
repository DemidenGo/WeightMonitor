//
//  ViewController.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 06.05.2023.
//

import UIKit

final class MeasurementsHistoryViewController: UIViewController {

    var viewModel: MeasurementsHistoryViewModelProtocol?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("weightMonitorTitle", comment: "Main screen title")
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = .vertical
        [weightWidgetView, chartLabel, chartImageView, historyLabel, tableColumnsTitlesView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var weightWidgetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .weightWidgetBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var scalesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "WeightWidgetIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var weightWidgetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("weightWidgetTitle", comment: "Weight widget title")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelTextColor.withAlphaComponent(0.4)
        return label
    }()

    private lazy var currentWeightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .labelTextColor
        label.text = viewModel?.measurements.first?.weight
        return label
    }()

    private lazy var weightChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor.withAlphaComponent(0.6)
        label.text = viewModel?.measurements.first?.weightChange
        return label
    }()

    private lazy var metricSystemSwitchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(true, animated: true)
        switchView.onTintColor = .interfacePurple
        switchView.addTarget(self, action: #selector(metricSystemSwitchAction), for: .valueChanged)
        return switchView
    }()

    private lazy var metricSystemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("metricSystem", comment: "Select metric system")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .labelTextColor
        return label
    }()

    private lazy var chartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("monthlyMeasurements", comment: "Monthly measurements chart title")
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .labelTextColor
        return label
    }()

    private lazy var chartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = traitCollection.userInterfaceStyle == .dark ? UIImage(named: "ChartStubDarkMode") : UIImage(named: "ChartStub")
        return imageView
    }()

    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("history", comment: "History title")
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .labelTextColor
        return label
    }()

    private lazy var tableColumnsTitlesView = HistoryTableColumnTitlesView()

    private lazy var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var addMeasurementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .interfacePurple
        let buttonImage = UIImage(named: "AddMeasurementButtonIcon")
        button.setImage(buttonImage, for: .normal)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 24
        button.layer.shadowColor = UIColor.addMeasurementButtonShadowColor.cgColor
        button.layer.shadowRadius = 16
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.addTarget(self, action: #selector(addNewMeasurementAction), for: .touchUpInside)
        return button
    }()

    private lazy var popupMessageView: UIView = {
        let view = UIView(frame: CGRect(x: 8,
                                        y: view.frame.height + 52,
                                        width: view.frame.width - 16,
                                        height: 52))
        view.backgroundColor = .labelTextColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.addSubview(popupMessageLabel)
        return view
    }()

    private lazy var popupMessageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16,
                                          y: 16,
                                          width: view.frame.width - 48,
                                          height: 20))
        label.backgroundColor = .labelTextColor
        label.textColor = .popupLabelTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        setupConstraints()
        bind()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                chartImageView.image = UIImage(named: "ChartStubDarkMode")
            } else {
                chartImageView.image = UIImage(named: "ChartStub")
            }
        }
    }

    // MARK: - Private funcs

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.measurementsObservable.bind { [weak self] measurements in
            self?.reloadMeasurementsHistory()
            self?.updateWeightWidget(for: measurements)
        } userAction: { [weak self] userAction in
            self?.showPopupMessage(for: userAction)
        }
    }

    private func reloadMeasurementsHistory() {
        historyTableView.performBatchUpdates {
            historyTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        guard let viewModel = viewModel, !viewModel.measurements.isEmpty else { return }
        historyTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }

    private func updateWeightWidget(for measurements: [MeasurementViewModel]) {
        if currentWeightLabel.text != measurements.first?.weight {
            currentWeightLabel.alpha = 0
            currentWeightLabel.text = measurements.first?.weight
            UIView.animate(withDuration: 2) { self.currentWeightLabel.alpha = 1 }
        }
        if weightChangeLabel.text != measurements.first?.weightChange {
            weightChangeLabel.alpha = 0
            weightChangeLabel.text = measurements.first?.weightChange
            UIView.animate(withDuration: 2) { self.weightChangeLabel.alpha = 1 }
        }
    }

    private func showPopupMessage(for userAction: UserAction) {
        switch userAction {
        case .addNewMeasurement:
            popupMessageLabel.text = NSLocalizedString("addMeasurementMessage",
                                                       comment: "New measurement pop-up message")
        case .deleteMeasurement:
            popupMessageLabel.text = NSLocalizedString("deleteMeasurementMessage",
                                                       comment: "Delete measurement pop-up message")
        case .editMeasurement:
            popupMessageLabel.text = NSLocalizedString("editMeasurementMessage",
                                                       comment: "Edit measurement pop-up message")
        case .switchMeasurementSystem:
            popupMessageLabel.text = NSLocalizedString("switchMeasurementSystemMessage",
                                                       comment: "Switch measurement system pop-up message")
        }
        switchUserInteractionCapability()
        view.addSubview(popupMessageView)
        UIView.animate(withDuration: 1) {
            self.popupMessageView.frame.origin.y = self.view.frame.height - 110
        }
        UIView.animate(withDuration: 1, delay: 2) {
            self.popupMessageView.frame.origin.y = self.view.frame.height + 52
        } completion: { [weak self] isCompleted in
            if isCompleted {
                self?.popupMessageView.removeFromSuperview()
                self?.switchUserInteractionCapability()
            }
        }
    }

    @objc private func addNewMeasurementAction() {
        guard let viewModel = viewModel else { return }
        let newMeasurementViewController = NewMeasurementViewController()
        newMeasurementViewController.viewModel = NewMeasurementViewModel(weightMeasure: viewModel.weightMeasureString)
        present(newMeasurementViewController, animated: true)
    }

    @objc private func metricSystemSwitchAction(_ sender: UISwitch) {
        viewModel?.switchMeasurementSystem()
    }

    private func switchUserInteractionCapability() {
        historyTableView.isUserInteractionEnabled.toggle()
        metricSystemSwitchView.isUserInteractionEnabled.toggle()
        addMeasurementButton.isUserInteractionEnabled.toggle()
    }

    private func setupConstraints() {
        [scrollView, addMeasurementButton].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)

        [screenTitleLabel, stackView, historyTableView].forEach { contentView.addSubview($0) }

        [scalesImageView, weightWidgetLabel, currentWeightLabel, weightChangeLabel, metricSystemSwitchView, metricSystemLabel].forEach { weightWidgetView.addSubview($0) }

        NSLayoutConstraint.activate([
            addMeasurementButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addMeasurementButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addMeasurementButton.widthAnchor.constraint(equalToConstant: 48),
            addMeasurementButton.heightAnchor.constraint(equalToConstant: 48),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            screenTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            screenTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56),
            screenTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56),

            stackView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            weightWidgetView.heightAnchor.constraint(equalToConstant: 129),

            scalesImageView.topAnchor.constraint(equalTo: weightWidgetView.topAnchor),
            scalesImageView.trailingAnchor.constraint(equalTo: weightWidgetView.trailingAnchor),

            weightWidgetLabel.topAnchor.constraint(equalTo: weightWidgetView.topAnchor, constant: 16),
            weightWidgetLabel.leadingAnchor.constraint(equalTo: weightWidgetView.leadingAnchor, constant: 16),

            currentWeightLabel.topAnchor.constraint(equalTo: weightWidgetLabel.bottomAnchor, constant: 6),
            currentWeightLabel.leadingAnchor.constraint(equalTo: weightWidgetView.leadingAnchor, constant: 16),

            weightChangeLabel.leadingAnchor.constraint(equalTo: currentWeightLabel.trailingAnchor, constant: 8),
            weightChangeLabel.bottomAnchor.constraint(equalTo: currentWeightLabel.bottomAnchor),

            metricSystemSwitchView.leadingAnchor.constraint(equalTo: weightWidgetView.leadingAnchor, constant: 16),
            metricSystemSwitchView.bottomAnchor.constraint(equalTo: weightWidgetView.bottomAnchor, constant: -16),

            metricSystemLabel.leadingAnchor.constraint(equalTo: metricSystemSwitchView.trailingAnchor, constant: 18),
            metricSystemLabel.bottomAnchor.constraint(equalTo: weightWidgetView.bottomAnchor, constant: -20.5),

            tableColumnsTitlesView.heightAnchor.constraint(equalToConstant: 27),

            historyTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            historyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            historyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            historyTableView.heightAnchor.constraint(equalToConstant: 518)
        ])
    }
}

// MARK: - UITableViewDelegate

extension MeasurementsHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        46
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteFromHistory(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMeasurementViewController = NewMeasurementViewController()
        newMeasurementViewController.viewModel = viewModel?.newMeasurementViewModel(for: indexPath)
        present(newMeasurementViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MeasurementsHistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.measurements.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell,
              let viewModel = viewModel else { return UITableViewCell() }
        let measurement = viewModel.measurements[indexPath.row]
        cell.set(weight: measurement.weight,
                 weightChange: viewModel.weightChange(for: indexPath),
                 date: viewModel.dateString(for: measurement.date))
        return cell
    }
}
