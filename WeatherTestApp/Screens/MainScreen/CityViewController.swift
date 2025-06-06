//
//  CityViewController.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

final class CityViewController: UIViewController {

    private let cityView = CityView()
    private let viewModel = CityViewModel()

    override func loadView() {
        super.loadView()
        view = cityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchWeather(for: Texts.defaultCity)
    }
}

private extension CityViewController {
    func setupView() {
        title = Texts.defaultCity
        view.backgroundColor = .systemBackground
    }

    func fetchWeather(for city: String) {
        viewModel.fetchWeather(for: city) { [weak self] result in
            switch result {
            case .success(let viewModel):
                self?.cityView.configure(with: viewModel)
            case .failure(let error):
                self?.showErrorAlert(with: error.errorDescription)
            }
        }
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(
            title: Texts.Alert.title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: Texts.Alert.cancelActionTitle, style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
