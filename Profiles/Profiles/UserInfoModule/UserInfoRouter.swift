//
//  UserInfoRouter.swift
//  Profiles
//
//  Created by Егор Шкарин on 04.07.2022.
//

import UIKit
import SimpleImageViewer

final class UserInfoRouter {
    private var viewController: UIViewController?
    
    func setViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }
}
extension UserInfoRouter: UserInfoRouterInput {
    func showImageScreen(with config: ImageViewerConfiguration) {
        let imageViewerController = ImageViewerController(configuration: config)
        viewController?.present(imageViewerController, animated: true)
    }
}
