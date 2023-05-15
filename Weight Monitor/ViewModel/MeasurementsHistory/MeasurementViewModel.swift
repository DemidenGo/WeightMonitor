//
//  Measurement.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

struct MeasurementViewModel: Equatable {
    let date: Date
    let weight: String
    let weightChange: String

    init(date: Date, weight: String, weightChange: String = "") {
        self.date = date
        self.weight = weight
        self.weightChange = weightChange
    }

    func convertWeightTo(_ measurementUnit: MeasurementSystem) -> MeasurementViewModel {
        let convertRatio: Float = measurementUnit == .metric ? 0.4536 : 2.2046
        let measurementUnitString = measurementUnit == .metric ? NSLocalizedString("kilos", comment: "Weight measure unit in metric system") : NSLocalizedString("pounds", comment: "Weight measure unit in british system")

        return MeasurementViewModel(
            date: self.date,
            weight: ((Float(self.weight.dropLast(3)) ?? 0) * convertRatio).cleanFractionalPart + measurementUnitString,
            weightChange: ((Float(self.weightChange.dropLast(3)) ?? 0) * convertRatio).cleanFractionalPart + measurementUnitString)
    }
}
