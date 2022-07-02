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
    let coreDataManager: СoreDataManagerProtocol
    let router: ProfileRouterInput
    private var isAllLoaded = false
    init(networkManager: NetworkManagerProtocol,
         coreDataManager: СoreDataManagerProtocol, router: ProfileRouterInput) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.router = router
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
    func makeLocalModelsFromCoreDataEntities(_ entities: [ProfileEntity]) -> [LocalProfileModel] {
        var arrayOfLocalModels = [LocalProfileModel]()
        for entity in entities {
            let age = String(entity.age)
            let dob = entity.dob ?? ""
            let name = entity.name ?? ""
            let email = entity.email ?? ""
            let pictureURL = entity.picture
            let gender = entity.gender ?? ""
            let localTime = entity.localTime ?? ""
            let localModel = LocalProfileModel(name: name,
                                               email: email,
                                               dob: dob,
                                               age: age,
                                               localTime: localTime,
                                               picture: pictureURL,
                                               gender: Gender(rawValue: gender) ?? .male)
            arrayOfLocalModels.append(localModel)
        }
        return arrayOfLocalModels
    }
}

extension ProfilesViewModel: ProfilesViewOutput {
    func showProfile(_ profile: LocalProfileModel) {
        router.showProfileCard(profile)
    }
    
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
                self.coreDataManager.saveToCoreData(models: localModels)
                view?.loadedProfiles(localModels)
                isAllLoaded = false
            } catch let networkError as URLError {
                coreDataManager.createContainer {[weak self] result in
                    guard let `self` = self else {
                        return
                    }
                    switch result {
                    case .success(let container):
                        let cdModels = self.coreDataManager.fetchResults(from: container,
                                                                    entityName: .ProfileEntity,
                                                                    modelType: ProfileEntity.self)
                        if let cdModels = cdModels, !self.isAllLoaded {
                            let localModels = self.makeLocalModelsFromCoreDataEntities(cdModels)
                            self.view?.loadedProfiles(localModels)
                            self.isAllLoaded = true
                        } else {
                            print("[DEBUG]", "В базе данных ничего нет")
                        }
                    case .failure(let error):
                        self.view?.showErrorMessage(title: "Something goes wrong", message: error.localizedDescription)
                        print("[DEBUG]", error.localizedDescription)
                    }
                }
                view?.showErrorMessage(title: "No intenet connection", message: networkError.localizedDescription)
            }
        }
    }
}
