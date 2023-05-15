//
//  WeightMonitorViewModel.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

enum MeasurementSystem {
    case metric
    case british

    var toggle: MeasurementSystem {
        switch self {
        case .metric: return .british
        case .british: return .metric
        }
    }
}

final class MeasurementsHistoryViewModel {

    private var measurementsStore: MeasurementsStoreProtocol?

    @Observable
    private(set) var measurements: [MeasurementViewModel] = []

    private var measurementSystem: MeasurementSystem = .metric

    private(set) var measurementsChanges: [String] = []

    init(measurementsStore: MeasurementsStoreProtocol = MeasurementsStore()) {
        self.measurementsStore = measurementsStore
        self.measurementsStore?.delegate = self
        getMeasurementsFromStore()
    }

    private func getMeasurementsFromStore() {
        guard let measurementsStore = measurementsStore else { return }
        calculateChanges(in: measurementsStore.measurements)
        measurements = measurementsStore.measurements.enumerated().map {
            MeasurementViewModel(date: $1.date ?? Date(),
                                 weight: $1.weight.cleanFractionalPart + weightMeasureString,
                                 weightChange: measurementsChanges[$0])
        }
    }

    private func calculateChanges(in measurements: [MeasurementCoreData]) {
        var arrayWithoutLastMeasurement = measurements.dropFirst()
        guard let firstMeasurement = measurements.last else { return }
        arrayWithoutLastMeasurement.append(firstMeasurement)
        let measurementsChangesFloat = zip(measurements, arrayWithoutLastMeasurement).map {
            $0.weight - $1.weight
        }
        measurementsChanges = measurementsChangesFloat.map {
            if $0 > 0 { return "+" + String($0.cleanFractionalPart) + weightMeasureString }
            return String($0.cleanFractionalPart + weightMeasureString)
        }
    }
}

// MARK: - MeasurementsHistoryViewModelProtocol

extension MeasurementsHistoryViewModel: MeasurementsHistoryViewModelProtocol {

    var weightMeasureString: String {
        switch measurementSystem {
        case .metric: return NSLocalizedString("kilos", comment: "Weight measure unit in metric system")
        case .british: return NSLocalizedString("pounds", comment: "Weight measure unit in british system")
        }
    }

    var measurementsObservable: Observable<[MeasurementViewModel]> {
        $measurements
    }

    func deleteFromHistory(at indexPath: IndexPath) {
        try? measurementsStore?.deleteFromStore(at: indexPath)
    }

    func dateString(for date: Date) -> String {
        date.isCurrentYear ? date.shortDateString : date.longDateString
    }

    func weightChange(for indexPath: IndexPath) -> String {
        indexPath.row == measurements.count - 1 ? "" : measurements[indexPath.row].weightChange
    }

    func newMeasurementViewModel(for indexPath: IndexPath) -> NewMeasurementViewModel {
        let measurement = measurements[indexPath.row]
        return NewMeasurementViewModel(
            currentDate: measurement.date,
            currentWeight: String(measurement.weight.dropLast(3)),
            weightMeasure: weightMeasureString)
    }

    func switchMeasurementSystem() {
        measurementSystem = measurementSystem.toggle
        switch measurementSystem {
        case .metric: measurements = measurements.map { $0.convertWeightTo(.metric) }
        case .british: measurements = measurements.map { $0.convertWeightTo(.british) }
        }
    }
}

// MARK: - MeasurementsStoreDelegate

extension MeasurementsHistoryViewModel: MeasurementsStoreDelegate {

    func didUpdateMeasurements() {
        getMeasurementsFromStore()
    }
}
