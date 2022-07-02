//
//  ProfilesProtocols.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

protocol ProfilesViewOutput: AnyObject {
    func fetchProfiles(page: Int, batchSize: Int)
    func showProfile(_ profile: LocalProfileModel)
}

protocol ProfilesViewInput: AnyObject {
    func loadedProfiles(_ profiles: [LocalProfileModel])
    func showErrorMessage(title: String, message: String)
}

protocol ProfileRouterInput: AnyObject {
    func showProfileCard(_ profile: LocalProfileModel)
}
