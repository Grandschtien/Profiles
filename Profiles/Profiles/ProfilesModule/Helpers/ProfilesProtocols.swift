//
//  ProfilesProtocols.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

protocol ProfilesViewOutput: AnyObject {
    func fetchProfiles(page: Int, batchSize: Int)
}

protocol ProfilesViewInput: AnyObject {
    func loadedProfiles(_ profiles: [LocalProfileModel])
}


