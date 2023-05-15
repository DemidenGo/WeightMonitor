//
//  MeasurementStoreDelegate.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol MeasurementsStoreDelegate: AnyObject {
    func didUpdateMeasurements()
}
