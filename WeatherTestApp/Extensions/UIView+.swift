//
//  UIView+.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 05.06.2025.
//

import UIKit

extension UIView {
    @discardableResult
    func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
