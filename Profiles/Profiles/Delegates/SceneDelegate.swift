//
//  SceneDelegate.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        guard let window = window else { return }
        coordinator = MainCoordinator(window: window,
                                      navigationController: navigationController)
        coordinator?.start()
    }
}

