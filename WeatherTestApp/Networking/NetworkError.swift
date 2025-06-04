//
//  NetworkError.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

enum NetworkError: Error {
    case apiKeyReadingError
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case decodingError(String)
    case unknownError(String)
}
