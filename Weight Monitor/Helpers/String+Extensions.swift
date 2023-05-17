//
//  String+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 17.05.2023.
//

import Foundation

let decimalNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    return formatter
}()

extension String {
    var floatFromString: Float { decimalNumberFormatter.number(from: self)?.floatValue ?? 0 }
}
