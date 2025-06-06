//
//  NetworkServiceProtocol.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func requestWeather(
        forCity city: String,
        forLastDays days: Int,
        completion: @escaping (Result<WeatherDTO, NetworkError>) -> Void
    )
}
