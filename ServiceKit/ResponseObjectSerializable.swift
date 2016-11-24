//
//  ResponseObjectSerializable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//


import Foundation

public protocol ResponseObjectSerializable {
    
    /**
     Given a dictionary, convert them to an objects
     - parameter dictionary: <#dictionary description#>
     - returns: An object that conforms the **ResponseObjectSerializable** protocol
     */
    init?(dictionary: [String : AnyObject])
}

public protocol ResponseCollectionSerializable {
    
    /**
     Given an array of dictionaries, convert them to an array of objects
     - parameter dictionaries: An array of dictionaries
     - returns: An object that conforms the **ResponseCollectionSerializable** protocol
     */
    static func collection(_ dictionaries: [[String : AnyObject]]) -> [Self]?
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(_ dictionaries: [[String : AnyObject]]) -> [Self]? {
        return dictionaries.flatMap({ Self(dictionary: $0) })
    }
}
