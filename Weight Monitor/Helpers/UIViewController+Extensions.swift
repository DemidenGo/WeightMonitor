//
//  UIViewController+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
