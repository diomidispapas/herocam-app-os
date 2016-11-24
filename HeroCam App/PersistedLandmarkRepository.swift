//
//  PersistedLandmarkRepository.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 01/10/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import CoreData

open class PersistedLandmarkRepository: NSObject {
    var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
        super.init()
    }
    
    
    func store(entity landmark: Landmark) -> Storage.SaveStatus {
        guard let imageURLString = landmark.wikipediaThumbnail?.absoluteString else {
            Log.ln("Error unwrapping image")/
            return .rolledBack
        }
        return self.store(entityWith: landmark.title, wikipediaSnippet: landmark.wikipediaSnippet, wikipediaURLString: landmark.wikipediaURL.absoluteString, imageURLString: imageURLString)
    }
    
    
    func store(entityWith title: String, wikipediaSnippet: String, wikipediaURLString: String, imageURLString: String) -> Storage.SaveStatus {
        let entityDescription = NSEntityDescription.entity(forEntityName: PersistedLandmark.entityName, in: self.storage.context)
        let managedObject = PersistedLandmark(entity: entityDescription!, insertInto: self.storage.context)
        managedObject.title = title
        managedObject.wikipediaSnippet = wikipediaSnippet
        managedObject.wikipediaURLString = wikipediaURLString
        managedObject.wikipediaThumbnailURLString = imageURLString
        return self.storage.save()
    }
    
    func delete(entity landmark: PersistedLandmark) -> Storage.SaveStatus {
        storage.context.delete(landmark)
        return self.storage.save()
    }
}
