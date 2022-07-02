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
    func setupFetchResultsController<T: NSManagedObject>(for context: NSManagedObjectContext,
                                                                  entityName: EntityName) -> NSFetchedResultsController<T>
    func clearCacheFromCoreData<T: NSManagedObject>(_ type: T.Type) 
}

final class СoreDataManager: СoreDataManagerProtocol {
    private let modelName: ModelName
    init(modelName: ModelName) {
        self.modelName = modelName
    }
    
    func clearCacheFromCoreData<T: NSManagedObject>(_ type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        createContainer { result in
            switch result {
            case .success(let container):
                do {
                    try container.viewContext.execute(deleteRequest)
                } catch let error as NSError {
                    print(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
    func setupFetchResultsController<T: NSManagedObject>(for context: NSManagedObjectContext,
                                                         entityName: EntityName) -> NSFetchedResultsController<T> {
        let request = NSFetchRequest<T>(entityName: EntityName.ProfileEntity.rawValue)
        let sortDescriptor = NSSortDescriptor(key: "age", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController<T>(fetchRequest: request,
                                                                    managedObjectContext: context,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        return fetchedResultController
    }
    enum ModelName: String {
        case ProfilesModel
    }
}
enum EntityName: String {
    case ProfileEntity
}
