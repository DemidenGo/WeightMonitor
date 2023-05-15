//
//  DatePickerCellDelegate.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

protocol DatePickerCellDelegate: AnyObject {
    func dateChanged(_ newDate: Date)
}
