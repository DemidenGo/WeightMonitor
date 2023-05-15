//
//  UIColor+Extensions.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 06.05.2023.
//

import UIKit

extension UIColor {
    static var viewBackgroundColor: UIColor { UIColor.systemBackground }
    static var weightWidgetBackground: UIColor { UIColor(named: "WeightWidgetBackground") ?? .systemGray5 }
    static var interfacePurple: UIColor { UIColor(named: "InterfacePurple") ?? .systemPurple }
    static var tableHeaderLineColor: UIColor { UIColor(named: "TableHeaderLineColor") ?? .systemGray2 }
    static var addMeasurementButtonShadowColor: UIColor { UIColor(named: "AddMeasurementButtonShadowColor") ?? .systemGray4 }
    static var dismissIndicatorColor: UIColor { UIColor(named: "DismissIndicatorColor") ?? .systemGray5 }
    static var labelTextColor: UIColor { UIColor(named: "LabelTextColor") ?? .black }
    static var popupLabelTextColor: UIColor { UIColor(named: "PopupLabelTextColor") ?? .white }
}
