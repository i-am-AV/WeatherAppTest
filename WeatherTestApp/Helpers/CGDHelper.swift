//
//  CGDHelper.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

func onMain(_ completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}
