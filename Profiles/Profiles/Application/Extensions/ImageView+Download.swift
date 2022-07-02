//
//  ImageView+Download.swift
//  Profiles
//
//  Created by Егор Шкарин on 01.07.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL?) {
        let cacheManager = Cache<String, Data>()
        guard let url = url else {
            return
        }
        if let data = cacheManager.value(forKey: url.absoluteString) {
            self.image = UIImage(data: data)
        } else {
            Task {
                do {
                    let imageData = try await NetworkManager.loadPhoto(url: url)
                    self.image = UIImage(data: imageData)
                    cacheManager.insert(imageData, forKey: url.absoluteString)
                } catch {
                    print(error.localizedDescription)
                    self.image = nil
                }
            }
        }
    }
}
