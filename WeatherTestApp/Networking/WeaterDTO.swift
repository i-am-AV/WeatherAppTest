//
//  WeaterDTO.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

struct WeatherDTO: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
    let localtime: Int

    enum CodingKeys: String, CodingKey {
        case name
        case localtime = "localtime_epoch"
    }
}

struct Current: Decodable {
    let temp: Double
    let wind: Double
    let humidity: Int
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case wind = "wind_kph"
        case humidity
        case condition
    }
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct Forecastday: Decodable {
    let date: Int
    let day: Day

    enum CodingKeys: String, CodingKey {
        case date = "date_epoch"
        case day
    }
}

struct Day: Decodable {
    let avgTemp: Double
    let maxWind: Double
    let avgHumidity: Int
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case avgTemp = "avgtemp_c"
        case maxWind = "maxwind_kph"
        case avgHumidity = "avghumidity"
        case condition
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
}
