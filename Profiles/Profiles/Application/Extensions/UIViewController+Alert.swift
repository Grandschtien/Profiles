//
//  UIViewController+Alert.swift
//  Profiles
//
//  Created by Егор Шкарин on 02.07.2022.
//

import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message : String) {
       let alertController = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
       )
        
       let OKAction = UIAlertAction(title: "OK", style: .default) { action in
           debugPrint("[DEBUG] You've pressed OK Button")
       }
       alertController.addAction(OKAction)
       self.present(
        alertController,
        animated: true,
        completion: nil
       )
     }
}
