//
//  ProfilesViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

final class ProfilesViewModel {
    weak var view: ProfilesViewInput?
    let networkManager: ProfilesNetworkManagerProtocol
    
    init(networkManager: ProfilesNetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension ProfilesViewModel: ProfilesViewOutput {
    func viewDidLoad() {
       
    }
}
