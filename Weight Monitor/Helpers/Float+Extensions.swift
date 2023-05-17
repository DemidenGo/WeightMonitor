//
//  Float+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 11.05.2023.
//

import Foundation

extension Float {

    var stringFromFloat: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            decimalNumberFormatter.maximumFractionDigits = 0
            return decimalNumberFormatter.string(from: NSNumber(value: self)) ?? ""
        } else {
            decimalNumberFormatter.maximumFractionDigits = 1
            return decimalNumberFormatter.string(from: NSNumber(value: self)) ?? ""
        }
    }
}
