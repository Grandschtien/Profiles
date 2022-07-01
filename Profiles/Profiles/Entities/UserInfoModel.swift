//
//  UserInfoModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

struct UserInfoModel {
    let picture: Data
    let name: String
    let gender: Gender
    let email: String
    let birthDay: Date
    let currentTime: Date
}
