//
//  StoryboardInstantiable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//


import UIKit

/**
 * A type that all `UIViewController` subclasses conform to. It provides a safe way to init view controllers from Storyboard via the ```instantiateFromStoryboard(storyboard: UIStoryboard) -> Self``` function. It also eliminates casting as `initFromStoryboard()` method automatically. returns the correct `UIViewController`'s subclass.
 */
protocol StoryboardInstantiable: class {
    static var storyboardIdentifier: String {get}
    static func instantiateFromStoryboard(_ storyboard: UIStoryboard) -> Self
}

extension UIViewController {
    
    // Thanks to generics, return automatically the right type
    fileprivate class func instantiateFromStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, type: T.Type) -> T {
        return storyboard.instantiateViewController( withIdentifier: self.storyboardIdentifier) as! T
    }
}

extension UIViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    class func instantiateFromStoryboard(_ storyboard: UIStoryboard) -> Self {
        return instantiateFromStoryboard(storyboard, type: self)
    }
}
