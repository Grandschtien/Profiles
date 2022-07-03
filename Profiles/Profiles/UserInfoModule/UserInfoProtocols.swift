//
//  UserInfoProtocols.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

protocol UserInfoViewInput: AnyObject {
    func presentProfile(_ profile: LocalProfileModel)
}
protocol UserInfoViewOutput: AnyObject {
    func viewDidLoad()
}

protocol UserInfoRouterInput: AnyObject {
    
}
