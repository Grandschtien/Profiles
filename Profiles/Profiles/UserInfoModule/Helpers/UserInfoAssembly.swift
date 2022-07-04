//
//  UserInfoAssembly.swift
//  Profiles
//
//  Created by Егор Шкарин on 03.07.2022.
//

import Foundation
import UIKit

final class UserInfoAssembly {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assebly(with profile: LocalProfileModel) -> UserInfoAssembly {
        let router = UserInfoRouter()
        let viewModel = UserInfoViewModel(profile: profile, router: router)
        let viewController = UserInfoViewController(output: viewModel)
        router.setViewController(viewController)
        viewModel.view = viewController
        
        return UserInfoAssembly(viewController: viewController)
    }
}
