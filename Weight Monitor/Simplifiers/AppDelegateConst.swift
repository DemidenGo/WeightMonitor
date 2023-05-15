//
//  AppDelegateConst.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import UIKit

var appDelegate: AppDelegate {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("Error: appDelegate not found")
    }
    return appDelegate
}
