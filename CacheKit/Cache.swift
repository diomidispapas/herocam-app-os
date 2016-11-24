//
//  Cache.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

public protocol CacheType {
    associatedtype T
    static func set(_ value: T?, withIdentifier identifier: String)
    static func get(with identifier: String) -> T?
}

public struct Cache: CacheType {
    fileprivate static let inMemoryCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: CacheType
    
    public static func get(with identifier: String) -> UIImage? {
    
        // If the identifier empty, return nil
        guard !identifier.isEmpty else {
            return nil
        }
        
        let path = cacheIdentifier(with: identifier)
        
        // Try the memory cache
        if let image = Cache.inMemoryCache.object(forKey: path as AnyObject) as? UIImage {
            return image
        }
        
        return nil
    }
    
    public static func set(_ value: UIImage?, withIdentifier identifier: String) {
        let path = cacheIdentifier(with: identifier)
        
        // If the image is nil, remove images from the cache
        guard value != nil else {
            Cache.inMemoryCache.removeObject(forKey: path as AnyObject)
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch _ {}
            return
        }
        
        // 2. Otherwise, keep the image in memory
        Cache.inMemoryCache.setObject(value!, forKey: path as AnyObject)
    }
    
    // MARK: Helper
    fileprivate static func cacheIdentifier(with value: String) -> String {
        return "com.herocamapp.cachekit.caches.\(value)"
    }
}
