//
//  Float+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 11.05.2023.
//

import Foundation

extension Float {
    var cleanFractionalPart: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
