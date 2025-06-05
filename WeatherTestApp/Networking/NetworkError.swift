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

    var errorDescription: String {
        switch self {
        case .apiKeyReadingError:
            "API key reading error"
        case .invalidURL:
            "Invalid URL"
        case .invalidResponse:
            "Invalid Response "
        case .invalidStatusCode(let code):
            "Invalid Status Code: \(code)"
        case .noData:
            "No Data"
        case .decodingError(let error):
            "Decoding Error: \(error)"
        case .unknownError(let error):
            "Unknown Error \(error)"
        }
    }
}
