//
//  Coordinator.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    func start() {
        setupInitialController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func setupInitialController() {
        let initialAssembly = ProfilesAssembly.assemble()
        navigationController.setViewControllers([initialAssembly.viewController], animated: true)
    }
}
