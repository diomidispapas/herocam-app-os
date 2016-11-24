//
//  PersistedLandmark.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 01/10/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import CoreData

class PersistedLandmark: NSManagedObject, LandmarkType, CoreDataPersistable {
    // MARK: CoreDataPersistable
    static var entityName = { return  "PersistedLandmark" }()

    // MARK: Properties
    @NSManaged var title: String
    @NSManaged var wikipediaSnippet: String
    @NSManaged var wikipediaURLString: String
    @NSManaged var wikipediaThumbnailURLString: String?
    @NSManaged var createdAt: Date
}
