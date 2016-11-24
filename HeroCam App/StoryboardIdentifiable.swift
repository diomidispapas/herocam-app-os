//
//  StoryboardIdentifiable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable: class {
    static var storyboardIdentifier: String {get}
}

extension UIStoryboard: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
