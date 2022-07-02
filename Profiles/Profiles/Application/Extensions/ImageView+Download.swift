//
//  ImageView+Download.swift
//  Profiles
//
//  Created by Егор Шкарин on 01.07.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: URL?) {
        guard let url = url else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        self.kf.setImage(with: resource, placeholder: UIImage(systemName: "person.fill"), options: [.cacheOriginalImage])
    }
    
}
