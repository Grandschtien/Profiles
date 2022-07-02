//
//  ProfilesViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation
import CoreData

final class ProfilesViewModel {
    weak var view: ProfilesViewInput?
    let networkManager: NetworkManagerProtocol
    let coreDataManager: СoreDataManagerProtocol
    private var flag = false
    init(networkManager: NetworkManagerProtocol,
         coreDataManager: СoreDataManagerProtocol) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
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
    func fetchProfiles(page: Int, batchSize: Int) {
        Task(priority: .high) {
            do {
                
                let arguments: [Arguments] = [.name, .email, .picture, .dob, .gender, .location]
                let data = try await networkManager.fetchData(numberOfPage: page,
                                                              count: batchSize,
                                                              arguments: arguments)
                coreDataManager.clearCacheFromCoreData(ProfileEntity.self)
                guard let decoded = JSONDecoder.decodeData(ProfilesModel.self, data: data) else {
                    fatalError()
                }
                let localModels = makeLocalModels(from: decoded)
                DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                    guard let `self` = self else { return }
                    self.coreDataManager.createContainer { result in
                        switch result {
                        case .success(let container):
                            let backContext = container.newBackgroundContext()
                            for profile in localModels {
                                let entity = ProfileEntity(context: backContext)
                                entity.name = profile.name
                                entity.dob = profile.dob
                                entity.picture = profile.picture
                                entity.localTime = profile.localTime
                                entity.age = Int16(profile.age) ?? 0
                                entity.email = profile.email
                                entity.gender = profile.gender.rawValue
                                do {
                                    try backContext.save()
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                view?.loadedProfiles(localModels)
                flag = false
            } catch let networkError as URLError {
                coreDataManager.createContainer {[weak self] result in
                    guard let `self` = self else {
                        return
                    }
                    switch result {
                    case .success(let container):
                        let fetchResultsController: NSFetchedResultsController<ProfileEntity> = self.coreDataManager.setupFetchResultsController(
                            for: container.viewContext,
                            entityName: .ProfileEntity
                        )
                        do {
                            try fetchResultsController.performFetch()
                        } catch let error  {
                            print(error.localizedDescription)
                        }
                        
                        let cdModels = fetchResultsController.fetchedObjects
                        if let cdModels = cdModels, !self.flag {
                            let localModels = self.makeLocalModelsFromCoreDataEntities(cdModels)
                            self.view?.loadedProfiles(localModels)
                            self.flag = true
                        } else {
                            print("Ошибка, в БД нет ничего, нужно кинуть ошибку, что нет инета и попросить подключиться к инету")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                view?.showErrorMessage(title: "No intenet connection", message: networkError.localizedDescription)
            }
        }
    }
}
