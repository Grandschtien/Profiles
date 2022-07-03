//
//  СoreDataManager.swift
//  Profiles
//
//  Created by Егор Шкарин on 01.07.2022.
//

import Foundation
import CoreData
 
protocol СoreDataManagerProtocol: AnyObject {
    func createContainer(completion: @escaping (Result<NSPersistentContainer, Error>) -> ())
    func setupFetchResultsController<T: NSManagedObject>(
        for context: NSManagedObjectContext,
        entityName: EntityName,
        sortDescriptor: NSSortDescriptor
    ) -> NSFetchedResultsController<T>
    func fetchResults<T: NSManagedObject>(
        from container: NSPersistentContainer,
        entityName: EntityName,
        modelType: T.Type,
        sort: (String, Bool)
    ) -> [T]?
    func saveToCoreData(models: [LocalProfileModel]) 
}

final class СoreDataManager: СoreDataManagerProtocol {
    private let modelName: ModelName
    init(modelName: ModelName) {
        self.modelName = modelName
    }
    
    /// Функция создания NSPersistentContainer
    /// - Parameter completion: completion блок, аргумент которого и есть контейнер
    func createContainer(completion: @escaping (Result<NSPersistentContainer, Error>) -> ()) {
        let container = NSPersistentContainer(name: modelName.rawValue)
        container.loadPersistentStores { _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            DispatchQueue.main.async  {
                completion(.success(container))
            }
        }
    }
    
    /// Функция создания NSFetchedResultsController
    /// - Parameters:
    ///   - context: констекст NSManagedObjectContext
    ///   - entityName: Название сущности
    /// - Returns: Возвращает готовый контроллер
    func setupFetchResultsController<T: NSManagedObject>(
        for context: NSManagedObjectContext,
        entityName: EntityName,
        sortDescriptor: NSSortDescriptor
    ) -> NSFetchedResultsController<T> {
        let request = NSFetchRequest<T>(entityName: EntityName.ProfileEntity.rawValue)
        let sortDescriptor = sortDescriptor
        request.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController<T>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultController
    }
    
    /// Функция получения данных из Core Data
    /// - Parameters:
    ///   - container: Контейнер NSPersistentContainer
    ///   - entityName: Название сущности
    ///   - modelType: Тип модели
    ///   - sort: String - поле в модели, Bool - ascending у NSSortDescriptor
    /// - Returns: Возвращает массив полученных данных
    func fetchResults<T: NSManagedObject>(
        from container: NSPersistentContainer,
        entityName: EntityName,
        modelType: T.Type,
        sort: (String, Bool)
    ) -> [T]? {
        let fetchResultsController: NSFetchedResultsController<T> = setupFetchResultsController(
            for: container.viewContext,
            entityName: entityName,
            sortDescriptor: makeSortDescriptor(field: sort.0, ascending: sort.1)
        )
        do {
            try fetchResultsController.performFetch()
            return fetchResultsController.fetchedObjects
        } catch let error  {
            print("[DEBUG]", error.localizedDescription)
            return nil
        }
    }
    
    /// Функция сохранения данных в Core Data
    /// - Parameter models: Массив локальных моделей
    func saveToCoreData(models: [LocalProfileModel]) {
        createContainer { result in
            switch result {
            case .success(let container):
                let backContext = container.newBackgroundContext()
                for profile in models {
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
                        debugPrint("[DEBUG]", error.localizedDescription)
                    }
                }
            case .failure(let error):
                debugPrint("[DEBUG]", error.localizedDescription)
            }
        }
    }
    
    func makeSortDescriptor(field: String, ascending: Bool) -> NSSortDescriptor {
        return NSSortDescriptor(key: field, ascending: ascending)
    }
    
    enum ModelName: String {
        case ProfilesModel
    }
}

enum EntityName: String {
    case ProfileEntity
}
