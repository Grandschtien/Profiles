//
//  UserInfoProtocols.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import SimpleImageViewer
import UIKit

protocol UserInfoViewInput: AnyObject {
    func presentProfile(_ profile: LocalProfileModel)
}
protocol UserInfoViewOutput: AnyObject {
    func viewDidLoad()
    func openPicture(imageView: UIImageView)
}

protocol UserInfoRouterInput: AnyObject {
    func showImageScreen(with config: ImageViewerConfiguration)
}
