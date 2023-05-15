//
//  NewMeasurementCellViewModelProtocol.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol NewMeasurementCellViewModelProtocol {
    var id: NewMeasurementCellViewModelID { get }
    var height: CGFloat { get }
}
