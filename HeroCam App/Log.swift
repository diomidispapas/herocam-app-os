//
//  Log.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

/**
 Custom logging that uses emojis in order to make the log report more intuitive
 
 - ln:    print a line
 - url:   prints a url
 - error: print an error
 - date:  print date
 - obj:   prints an object (subclass of NSObject)
 - other: prints anything else
 */
public enum Log {
    case ln(_: String)
    case url(_: String)
    case error(_: NSError)
    case date(_: Foundation.Date)
    case obj(_: Any)
    case other(_: Any)
}

// Using the postfix operation in order to basically enable/disable a Log. “ /” symbol it’s the closest to commenting syntax without actually creating a comment
postfix operator /

postfix public func / (target: Log?) -> Void {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        #if DEBUG
            print(emoji + " " + String(describing: object))
        #endif
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
        
    case .url(let url):
        log("🌏", url)
        
    case .error(let error):
        log("❗️", error)
        
    case .other(let any):
        log("⚪️", any)
        
    case .obj(let obj):
        log("◽️", obj)
        
    case .date(let date):
        log("🕒", date)
    }
}
