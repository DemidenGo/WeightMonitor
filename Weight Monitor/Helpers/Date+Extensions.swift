//
//  Date+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation

let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM"
    formatter.locale = Locale.current
    return formatter
}()

let longDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    formatter.locale = Locale.current
    return formatter
}()

extension Date {
    var shortDateString: String { shortDateFormatter.string(from: self) }
    var longDateString: String { longDateFormatter.string(from: self) }
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isCurrentYear: Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.year, from: Date()) == calendar.component(.year, from: self)
    }
}
