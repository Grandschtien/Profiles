//
//  ProfilesViewModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

final class ProfilesViewModel {
    //MARK: - view input
    weak var view: ProfilesViewInput?
    //MARK: - properties
    let networkManager: NetworkManagerProtocol
    let coreDataManager: СoreDataManagerProtocol
    let router: ProfileRouterInput
    private var isAllLoaded = false
    private var isAlertHasBeenShown = false
    //MARK: -  init
    init(networkManager: NetworkManagerProtocol,
         coreDataManager: СoreDataManagerProtocol,
         router: ProfileRouterInput) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.router = router
    }
    
    /// Функция делает из моделей из сети локальные модели для передачи в адаптер
    /// - Parameter model: модель из сети
    /// - Returns: массив локальных моделй
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
            let localTime = model.location.timezone.offset
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
    
    /// Функция делает из моделей Core Data локальные модели
    /// - Parameter entities: Сущность из Core Data
    /// - Returns: Массив локальных моделей
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
    
    /// Функция для похода в сеть и получения элементов на странице page с количеством batchSize
    /// - Parameters:
    ///   - page: Номер страницы
    ///   - batchSize: Количество элементов на странице
    func fetchProfiles(page: Int, batchSize: Int) {
        Task(priority: .high) {
            do {
                let arguments: [Arguments] = [.name, .email, .picture, .dob, .gender, .location]
                let data = try await networkManager.fetchData(numberOfPage: page,
                                                              count: batchSize,
                                                              arguments: arguments)
                
                guard let decoded = JSONDecoder.decodeData(ProfilesModel.self, data: data) else {
                    view?.showErrorMessage(title: "Decoder error",
                                           message: "Cannot decode data, please, try to restart app")
                    return
                }
                let localModels = makeLocalModels(from: decoded)
                self.coreDataManager.saveToCoreData(models: localModels)
                view?.loadedProfiles(localModels)
                isAllLoaded = false
                isAlertHasBeenShown = false
            } catch let networkError as URLError {
                coreDataManager.createContainer {[weak self] result in
                    guard let `self` = self else {
                        return
                    }
                    switch result {
                    case .success(let container):
                        let cdModels = self.coreDataManager.fetchResults(
                            from: container,
                            entityName: .ProfileEntity,
                            modelType: ProfileEntity.self,
                            sort: ("age", true)
                        )
                        if let cdModels = cdModels, !self.isAllLoaded {
                            let localModels = self.makeLocalModelsFromCoreDataEntities(cdModels)
                            self.view?.loadedProfiles(localModels)
                            self.isAllLoaded = true
                        } else {
                            debugPrint("[DEBUG]", "В базе данных ничего нет")
                        }
                    case .failure(let error):
                        self.view?.showErrorMessage(title: "Something went wrong", message: error.localizedDescription)
                        debugPrint("[DEBUG]", error.localizedDescription)
                    }
                }
                if !isAlertHasBeenShown {
                    view?.showErrorMessage(title: "No intenet connection",
                                           message: networkError.localizedDescription)
                    isAlertHasBeenShown = true
                }
            }
        }
    }
}
