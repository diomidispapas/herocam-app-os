//
//  Failable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 12/25/15.
//  Copyright © 2015 Diomidis Papas. All rights reserved.
//

import Foundation

public enum Failable<T, E: Error> {
    case success(T)
    case failure(E)
    
    //MARK: Initialization
    public init(_ value: T) {
        self = .success(value)
    }
    
    public init(_ error: E) {
        self = .failure(error)
    }
    
    public var failed: Bool {
        switch self {
        case .failure( _):
            return true
            
        default:
            return false
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: E? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}
