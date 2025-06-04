//
//  NetworkService.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import Foundation

private enum Constant {
    enum ApiKey{
        static let key = "API_KEY"
    }
    enum Request {
        static let timeout: TimeInterval = 10
    }
    enum StatusCode {
        static let rangeOfSuccessful = (200..<300)
    }
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func requestWeather(
        forCity city: String,
        forLastDays days: Int,
        completion: @escaping (Result<WeatherDTO, NetworkError>) -> ()
    ) {
        guard
            let apiKey = Bundle.main.object(forInfoDictionaryKey: Constant.ApiKey.key) as? String
        else {
            completion(.failure(.apiKeyReadingError))
            return
        }

        guard
            let url = Endpoint(city: city, days: days, apiKey: apiKey).getURL()
        else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Constant.Request.timeout)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.unknownError(error.localizedDescription)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard Constant.StatusCode.rangeOfSuccessful.contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(WeatherDTO.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }

        dataTask.resume()
    }
}
