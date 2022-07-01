//
//  ProfilesViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

final class ProfilesViewModel {
    weak var view: ProfilesViewInput?
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func makeLocalModels(from model: ProfilesModel) -> [LocalProfileModel] {
        var arrayOfLocalModels = [LocalProfileModel]()
        for model in model.profiles {
            let age = String(model.dob.age)
            let dob = model.dob.date.dateFromString()
            let dobString = dob?.formatToString(using: .ddMMyy) ?? "00.00.0000"
            let name = model.name.first + " " + model.name.last
            let email = model.email
            let pictureURL = URL(string: model.picture.large)
            let gender = model.gender
            let localTime = Date().getTime(withOffset: model.location.timezone.offset)
            let localModel = LocalProfileModel(name: name,
                                               email: email,
                                               dob: dobString,
                                               age: age,
                                               localTime: localTime,
                                               picture: pictureURL,
                                               gender: gender)
            arrayOfLocalModels.append(localModel)
        }
        return arrayOfLocalModels
    }
}

extension ProfilesViewModel: ProfilesViewOutput {
    func fetchProfiles(page: Int, batchSize: Int) {
        Task(priority: .high) {
            do {
                let arguments: [Arguments] = [.name, .email, .picture, .dob, .gender, .location]
                let data = try await networkManager.fetchData(numberOfPage: page,
                                                              count: batchSize,
                                                              arguments: arguments)
                guard let decoded = JSONDecoder.decodeData(ProfilesModel.self, data: data) else {
                    fatalError()
                }
                let localModels = makeLocalModels(from: decoded)
                view?.loadedProfiles(localModels)
            } catch let error as URLError {
                //TODO: Получать из coreData, если не получится, тогда выбрасывать ошибку.
                print(error.localizedDescription)
            }
        }
    }
}
