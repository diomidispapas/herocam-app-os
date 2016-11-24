//
//  Storage.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 30/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import CoreData

/// ```NSPersistentStoreCoordinator``` extension
extension NSPersistentStoreCoordinator {
    
    /// ```NSPersistentStoreCoordinator``` error types
    public enum CoordinatorError: Error {
        /// ```.momd``` file not found
        case modelFileNotFound
        /// ```NSManagedObjectModel``` creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
    }
    
    /// Return ```NSPersistentStoreCoordinator``` object
    static func coordinator(_ name: String) throws -> NSPersistentStoreCoordinator? {
        
        guard let modelURL =  Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { throw CoordinatorError.storePathNotFound }
        
        do {
        let url = documents.appendingPathComponent("\(name).sqlite")
        let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
        NSInferMappingModelAutomaticallyOption : true ]
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw error
        }
        
        return coordinator
    }
}


struct Storage {
    static var shared = Storage()
    static let modelName = "HeroCamModel"
 
    @available(iOS 10.0, *)
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            Log.ln("CoreData: Inited \(storeDescription)")/
            guard error == nil else {
                Log.ln("CoreData: Unresolved error \(error)")/
                return
            }
        })
        return container
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(modelName)
        } catch {
            Log.ln("CoreData: Unresolved error \(error)")/
        }
        return nil
    }()
    
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: Public methods
    
    enum SaveStatus {
        case saved, rolledBack, hasNoChanges
    }
    
    var context: NSManagedObjectContext {
        mutating get {
            if #available(iOS 10.0, *) {
                return persistentContainer.viewContext
            } else {
                return managedObjectContext
            }
        }
    }
    
    mutating func save() -> SaveStatus {
        if context.hasChanges {
            do {
                try context.save()
                return .saved
            } catch {
                context.rollback()
                return .rolledBack
            }
        }
        return .hasNoChanges
    }
}
