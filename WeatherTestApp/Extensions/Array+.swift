//
//  Array+.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 05.06.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if (0..<self.count).contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
