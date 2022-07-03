//
//  UserInfoViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

final class UserInfoViewModel {
    weak var view: UserInfoViewInput?
    private let profile: LocalProfileModel
    
    init(profile: LocalProfileModel) {
        self.profile = profile
    }
}

extension UserInfoViewModel: UserInfoViewOutput {
    func viewDidLoad() {
        view?.presentProfile(profile)
    }
}
