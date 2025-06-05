//
//  CityViewController.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

#warning("Получать город по текущему местоположению")

private enum Constant {
    enum City {
        static let name: String = "Moscow"
    }
    enum Alert {
        static let title: String = "Error"
        static let cancelActionTitle: String = "Cancel"
    }
}

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
        fetchWeather(for: Constant.City.name)
    }
}

private extension CityViewController {
    func setupView() {
        title = Constant.City.name
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
            title: Constant.Alert.title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: Constant.Alert.cancelActionTitle, style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}


import SwiftUI

// MARK: - Обертка для UIViewController
struct ViewControllerWrapper<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController
    
    init(_ viewControllerBuilder: @escaping () -> ViewController) {
        self.viewController = viewControllerBuilder()
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {

    }
}

// MARK: - Пример использования
#if DEBUG
struct MyViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerWrapper {
            let nav = UINavigationController(rootViewController: CityViewController())
            nav.navigationBar.prefersLargeTitles = true
            
            return nav
        }
        .navigationTitle(Constant.City.name)
    }
}
#endif
