//
//  Int+.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 06.06.2025.
//

import Foundation

enum DateFormat: String {
    case ddMMMMyyyy = "dd MMMM yyyy"
    case dMMMM = "d MMMM"
}

extension Int {
    func formattedDateString(withFormat format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}
