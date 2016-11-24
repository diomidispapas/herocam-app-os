//
//  Persistable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 01/10/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

protocol Persistable { }

protocol CoreDataPersistable: Persistable {
    static var entityName: String { get }
}
