//
//  MeasurementViewModel.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 09.05.2023.
//

import Foundation

enum NewMeasurementAppearance {
    
    case datePickerIsVisible
    case datePickerIsHidden

    var cellViewModels: [NewMeasurementCellViewModelProtocol] {
        switch self {
        case .datePickerIsHidden:
            return [NewMeasurementDateCellViewModel(),
                    NewMeasurementWeightCellViewModel()]
        case .datePickerIsVisible:
            return [NewMeasurementDateCellViewModel(),
                    NewMeasurementDatePickerCellViewModel(),
                    NewMeasurementWeightCellViewModel()]
        }
    }

    var toggle: NewMeasurementAppearance {
        switch self {
        case .datePickerIsHidden: return .datePickerIsVisible
        case .datePickerIsVisible: return .datePickerIsHidden
        }
    }
}

final class NewMeasurementViewModel {

    private var measurementsStore: MeasurementsStoreProtocol?

    private(set) var weightMeasureString: String

    @Observable
    private var currentAppearance: NewMeasurementAppearance = .datePickerIsHidden

    @Observable
    private(set) var currentDate: Date

    private(set) var currentWeight: String

    private var datePickerIsHidden: Bool {
        currentAppearance == .datePickerIsHidden
    }

    private var datePickerIsVisible: Bool {
        currentAppearance == .datePickerIsVisible
    }

    private var dateViewModel: NewMeasurementCellViewModelProtocol {
        currentAppearance.cellViewModels[0]
    }

    private var datePickerViewModel: NewMeasurementCellViewModelProtocol {
        currentAppearance.cellViewModels[1]
    }

    private var weightViewModel: NewMeasurementCellViewModelProtocol {
        if datePickerIsVisible {
            return currentAppearance.cellViewModels[2]
        }
        return currentAppearance.cellViewModels[1]
    }

    init(currentDate: Date = Date().startOfDay,
         currentWeight: String = "",
         measurementsStore: MeasurementsStoreProtocol = MeasurementsStore(),
         weightMeasure: String) {
        self.currentDate = currentDate
        self.currentWeight = currentWeight
        self.measurementsStore = measurementsStore
        self.weightMeasureString = String(weightMeasure.dropFirst())
    }
}

// MARK: - MeasurementViewModelProtocol

extension NewMeasurementViewModel: NewMeasurementViewModelProtocol {

    var currentAppearanceObservable: Observable<NewMeasurementAppearance> {
        $currentAppearance
    }

    var currentDateObservable: Observable<Date> {
        $currentDate
    }

    var dateStringForCurrentDate: String {
        if currentDate.isToday { return NSLocalizedString("today", comment: "Text representation of the date") }
        if currentDate.isYesterday { return NSLocalizedString("yesterday", comment: "Text representation of the date") }
        return currentDate.isCurrentYear ? currentDate.shortDateString : currentDate.longDateString
    }

    var numberOfRows: Int {
        currentAppearance.cellViewModels.count
    }

    func cellViewModel(for row: Int) -> NewMeasurementCellViewModelProtocol {
        switch row {
        case 0: return dateViewModel
        case 1: return datePickerIsHidden ? weightViewModel : datePickerViewModel
        case 2: return weightViewModel
        default:
            fatalError("Error: row does not exist")
        }
    }

    func height(for row: Int) -> CGFloat {
        cellViewModel(for: row).height
    }

    func didTapDate() {
        currentAppearance = currentAppearance.toggle
    }

    func dateChanged(_ newDate: Date) {
        currentDate = newDate.startOfDay
    }

    func weightChanged(_ newWeight: String) {
        currentWeight = newWeight
    }

    func hideDatePicker() {
        if datePickerIsVisible {
            currentAppearance = .datePickerIsHidden
        }
    }

    func addCurrentMeasurement() {
        try? measurementsStore?.save(MeasurementViewModel(date: currentDate, weight: currentWeight))
    }
}
