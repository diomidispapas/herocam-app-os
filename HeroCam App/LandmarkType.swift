//
//  LandmarkType.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/3/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

protocol LandmarkType {
    /// Title of the Landmark
    var title: String { get }
    
    /// Wikipedia Snippet
    var wikipediaSnippet: String { get }
    
    /// Wikipedia link
    var wikipediaURLString: String { get }

    /// Image link
    var wikipediaThumbnailURLString: String? { get }
}
