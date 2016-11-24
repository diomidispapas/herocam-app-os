//
//  NSUserDefaults+Additions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/20/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

extension UserDefaults {

    /// Sets value for `key`
    public subscript(key: String) -> Any? {
        get {
            // return untyped Proxy
            // (make sure we don't fall into infinite loop)
            let proxy: Proxy = self[key]
            return proxy
        }
        set {
            guard let newValue = newValue else {
                removeObject(forKey: key)
                return
            }
            
            switch newValue {
            // @warning This should always be on top of Int because a cast
            // from Double to Int will always succeed.
            case let v as Double: self.setValue(v, forKey: key)
            case let v as Int: self.setValue(v, forKey: key)
            case let v as Bool: self.setValue(v, forKey: key)
            default: self.setValue(newValue as AnyObject, forKey: key)
            }
        }
    }
    
    /// Returns `true` if `key` exists
    func hasKey(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    /// Removes value for `key`
    func remove(_ key: String) {
        removeObject(forKey: key)
    }
    
    /// `Proxy`
    class Proxy {
        fileprivate let defaults: UserDefaults
        fileprivate let key: String
        
        fileprivate init(_ defaults: UserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: Getters
        var object: Any? {
            return defaults.object(forKey: key)
        }
        
        var string: String? {
            return defaults.string(forKey: key)
        }
        
        var array: [Any]? {
            return defaults.array(forKey: key)
        }
        
        var dictionary: [String: Any]? {
            return defaults.dictionary(forKey: key)
        }
        
        var int: Int? {
            return defaults.integer(forKey: key)
        }
        
        var double: Double? {
            return defaults.double(forKey: key)
        }
        
        var bool: Bool? {
            return defaults.bool(forKey: key)
        }
        
        // MARK: Non-Optional Getters
        
        var stringValue: String {
            return string ?? ""
        }
        
        var arrayValue: [Any] {
            return array ?? []
        }
        
        var dictionaryValue: [String: Any] {
            return dictionary ?? [:]
        }
        
        var intValue: Int {
            return int ?? 0
        }
        
        var doubleValue: Double {
            return double ?? 0
        }
        
        var boolValue: Bool {
            return bool ?? false
        }
    }
    
    /// Returns getter proxy for `key`
    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }

}


