//
//  LocalProfileModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

struct LocalProfileModel: Hashable {
    let name: String
    let email: String
    let dob: String
    let age: String
    let localTime: String
    let picture: URL?
    let gender: Gender
}
