//
//  PersistedLandmarksDataSource.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 01/10/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import CoreData

protocol PersistedLandmarksDataSourceDelegate: NSObjectProtocol {
    func dataSourceDidChange(_ dataSource: PersistedLandmarksDataSource)
}

open class PersistedLandmarksDataSource: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: PersistedLandmarksDataSourceDelegate?
    let managedObjectContext: NSManagedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<PersistedLandmark> = {
        let fetchRequest = NSFetchRequest<PersistedLandmark>(entityName: PersistedLandmark.entityName)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false) ]
        let fetchedResultsController = NSFetchedResultsController<PersistedLandmark>(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            Log.error(error)/
        }
        
        return fetchedResultsController
    }()
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfObjectsInSection(_ section: Int) -> Int {
        return (fetchedResultsController.sections![section].numberOfObjects)
    }
    
    func object(atIndexPath indexPath: IndexPath) -> PersistedLandmark {
        let managedObject = fetchedResultsController.object(at: indexPath)
        return managedObject 
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataSourceDidChange(self)
    }
}
