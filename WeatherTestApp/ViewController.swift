//
//  ViewController.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

final class ViewController: UIViewController {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.requestWeather(forCity: "Moscow", forLastDays: 5) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

