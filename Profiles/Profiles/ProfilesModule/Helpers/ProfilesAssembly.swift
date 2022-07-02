//
//  ProfilesAssembly.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import UIKit

final class ProfilesAssembly {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assemble() -> ProfilesAssembly {
        let networkManager = NetworkManager()
        let coreDataManager = СoreDataManager(modelName: .ProfilesModel)
        let viewModel = ProfilesViewModel(networkManager: networkManager,
                                          coreDataManager: coreDataManager)
        let viewController = ProfilesViewController(output: viewModel)
        viewModel.view = viewController
        return ProfilesAssembly(viewController: viewController)
    }
}
