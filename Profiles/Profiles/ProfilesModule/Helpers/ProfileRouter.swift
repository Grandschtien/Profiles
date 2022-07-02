//
//  ProfileRouter.swift
//  Profiles
//
//  Created by Егор Шкарин on 02.07.2022.
//

import Foundation
import UIKit

final class ProfileRouter {
    private var viewController: UIViewController?
    func setViewController(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ProfileRouter: ProfileRouterInput {
    func showProfileCard(_ profile: LocalProfileModel) {
        print(profile)
    }
}
