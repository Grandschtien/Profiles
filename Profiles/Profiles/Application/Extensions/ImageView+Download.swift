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
        guard let url = url else {
            return
        }
        Task {
            do {
                let imageData = try await NetworkManager.loadPhoto(url: url)
                self.image = UIImage(data: imageData)
            } catch {
                print(error.localizedDescription)
                self.image = nil
            }
        }
    }
}
