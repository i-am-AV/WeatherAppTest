//
//  SceneDelegate.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(using: windowScene)
    }
}

private extension SceneDelegate {
    func setupWindow(using windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: CityViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        ]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

