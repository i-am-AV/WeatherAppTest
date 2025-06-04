//
//  Endpoint.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

struct Endpoint {
    private let city: String
    private let days: Int
    private let apiKey: String

    init(city: String, days: Int, apiKey: String) {
        self.city = city
        self.days = days
        self.apiKey = apiKey
    }

    func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/forecast.json"

        components.queryItems = [
            URLQueryItem(name: "q", value: city.prepareForUsing()),
            URLQueryItem(name: "days", value: String(days).prepareForUsing()),
            URLQueryItem(name: "key", value: apiKey.prepareForUsing())
        ]

        return components.url
    }
}

private extension String {
    @discardableResult
    func prepareForUsing() -> Self {
        let prettyString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return prettyString
    }
}
