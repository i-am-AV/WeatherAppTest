//
//  CityViewModel.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit.UIImage
import Foundation

private enum Constant {
    static let unknown = "N/A"
    /// Бесплатный план не позволяет получать больше 3 дней
    static let defaultDaysNumber = 3
}

final class CityViewModel {
    struct Day {
        let day: String
        let icon: UIImage?
        let description: String
        let temperature: String
        let windSpeed: String
        let humidity: String
    }
    
    var date: String {
        guard let localtime = currentWeather?.location.localtime else { return Constant.unknown }
        return String(localtime.formattedDateString(withFormat: .ddMMMMyyyy))
    }
    
    var name: String {
        currentWeather?.location.name ?? Constant.unknown
    }
    
    var image: UIImage?
    
    var temperature: String {
        guard let temp = currentWeather?.current.temp else { return Constant.unknown }
        return String(temp)
    }
    
    var conditionText: String {
        currentWeather?.current.condition.text ?? Constant.unknown
    }
    
    var windSpeed: String {
        guard let wind = currentWeather?.current.wind else { return Constant.unknown }
        return String(wind)
    }
    
    var humidity: String {
        guard let humidity = currentWeather?.current.humidity else { return Constant.unknown }
        return String(humidity)
    }
    
    var days: [Day] {
        var days: [Day] = []
        guard let forecastdays = currentWeather?.forecast.forecastday else { return [] }
        for (i, value) in forecastdays.enumerated() {
            let day: String = value.date.formattedDateString(withFormat: .dMMMM)
            let icon: UIImage? = forecastdaysImages[safe: i] ?? UIImage()
            let description: String = value.day.condition.text
            let temperature: String = String(value.day.avgTemp)
            let windSpeed: String = String(value.day.maxWind)
            let humidity: String = String(value.day.avgHumidity)
            
            days.append(
                Day(
                    day: day,
                    icon: icon,
                    description: description,
                    temperature: temperature,
                    windSpeed: windSpeed,
                    humidity: humidity
                )
            )
        }
        return days
    }
    
    private let networkService: NetworkServiceProtocol
    private let imageLoader: ImageLoader
    
    private var currentWeather: WeatherDTO?
    private var forecastdaysImages: [UIImage?] = []
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        imageLoader: ImageLoader = .shared
    ) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }
    
    func fetchWeather(
        for city: String,
        forLastDays days: Int = Constant.defaultDaysNumber,
        completion: @escaping (Result<CityViewModel, NetworkError>) -> Void
    ) {
        networkService.requestWeather(forCity: city, forLastDays: days) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let weather):
                self.currentWeather = weather

                let group = DispatchGroup()

                group.enter()
                if let icon = self.currentWeather?.current.condition.icon {
                    self.imageLoader.loadImage(from: icon) { [weak self] image in
                        self?.image = image
                        group.leave()
                    }
                }
                
                if let forecastdays = self.currentWeather?.forecast.forecastday {
                    for forecastday in forecastdays {
                        group.enter()
                        let icon = forecastday.day.condition.icon
                        self.imageLoader.loadImage(from: icon) { [weak self] image in
                            self?.forecastdaysImages.append(image)
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(self))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
