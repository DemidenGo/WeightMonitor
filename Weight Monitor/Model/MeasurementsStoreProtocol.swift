//
//  MeasurementsStoreProtocol.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol MeasurementsStoreProtocol {
    var delegate: MeasurementsStoreDelegate? { get set }
    var measurements: [MeasurementCoreData] { get }
    func save(_ measurement: MeasurementViewModel) throws
    func deleteFromStore(at indexPath: IndexPath) throws
}
