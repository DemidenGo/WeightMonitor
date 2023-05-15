//
//  WeightCellDelegate.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol WeightCellDelegate: AnyObject {
    func didEnter(weight: String)
}
