//
//  UserInfoViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import SimpleImageViewer
import UIKit

final class UserInfoViewModel {
    weak var view: UserInfoViewInput?
    private let profile: LocalProfileModel
    private let router: UserInfoRouterInput
    init(profile: LocalProfileModel, router: UserInfoRouterInput) {
        self.profile = profile
        self.router = router
    }
}

extension UserInfoViewModel: UserInfoViewOutput {
    func openPicture(imageView: UIImageView) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        router.showImageScreen(with: configuration)
    }
    
    func viewDidLoad() {
        view?.presentProfile(profile)
    }
}
