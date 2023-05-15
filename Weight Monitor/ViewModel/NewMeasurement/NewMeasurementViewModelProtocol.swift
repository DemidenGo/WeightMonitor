//
//  MeasurementViewModelProtocol.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 09.05.2023.
//

import Foundation

protocol NewMeasurementViewModelProtocol {
    var currentAppearanceObservable: Observable<NewMeasurementAppearance> { get }
    var currentDateObservable: Observable<Date> { get }
    var currentDate: Date { get }
    var currentWeight: String { get }
    var dateStringForCurrentDate: String { get }
    var numberOfRows: Int { get }
    var weightMeasureString: String { get }
    func didTapDate()
    func cellViewModel(for row: Int) -> NewMeasurementCellViewModelProtocol
    func height(for row: Int) -> CGFloat
    func dateChanged(_ newDate: Date)
    func weightChanged(_ newWeight: String)
    func hideDatePicker()
    func addCurrentMeasurement()
}
