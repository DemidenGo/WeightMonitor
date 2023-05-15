//
//  MeasurementsHistoryViewModelProtocol.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol MeasurementsHistoryViewModelProtocol {
    var measurements: [MeasurementViewModel] { get }
    var measurementsChanges: [String] { get }
    var measurementsObservable: Observable<[MeasurementViewModel]> { get }
    var weightMeasureString: String { get }
    func deleteFromHistory(at indexPath: IndexPath)
    func dateString(for date: Date) -> String
    func weightChange(for indexPath: IndexPath) -> String
    func newMeasurementViewModel(for indexPath: IndexPath) -> NewMeasurementViewModel
    func switchMeasurementSystem()
}
