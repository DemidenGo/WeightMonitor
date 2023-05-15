//
//  ObservableWrapper.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 09.05.2023.
//

import Foundation

enum UserAction {
    case addNewMeasurement, deleteMeasurement, editMeasurement, switchMeasurementSystem
}

@propertyWrapper
final class Observable<Value> {

    private var onChange: ((Value) -> Void)? = nil
    private var userAction: ((UserAction) -> Void)? = nil

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
            if let newValue = wrappedValue as? [MeasurementViewModel],
               let oldValue = oldValue as? [MeasurementViewModel] {
                if newValue.count > oldValue.count {
                    userAction?(.addNewMeasurement)
                    return
                }
                if newValue.count < oldValue.count {
                    userAction?(.deleteMeasurement)
                    return
                }
                if newValue.first?.weight.suffix(2) != oldValue.first?.weight.suffix(2) {
                    userAction?(.switchMeasurementSystem)
                    return
                }
                if newValue.count == oldValue.count, newValue != oldValue { userAction?(.editMeasurement) }
            }
        }
    }

    var projectedValue: Observable {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void, userAction: ((UserAction) -> Void)? = nil) {
        self.onChange = action
        self.userAction = userAction
    }
}
