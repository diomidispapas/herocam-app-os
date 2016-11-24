//
//  Landmark.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation
import ServiceKit

/// Class that repsresents a Landmark
struct Landmark: LandmarkType, ResponseObjectSerializable {
    
    //MARK: Serialization Keys
    
    struct SerializationKeys {
        static let LandmarkKey = "landmark"
        static let WikipediaLinkKey = "wikipedia_link"
        static let WikipediaSnippetKey = "wikipedia_snippet"
        static let WikipediaThumbnailLinkKey = "wikipedia_thumbnail"
    }
    
    //MARK: LandmarkType
    
    let title: String
    let wikipediaSnippet: String
    let wikipediaURLString: String
    var wikipediaThumbnailURLString: String?

    /// Convenience Wikipedia link
    var wikipediaURL: URL {
        get {
            return  URL(string: wikipediaURLString)!
        }
    }

    /// Convenience Wikipedia Image link
    var wikipediaThumbnail: URL? {
        get {
            return (wikipediaThumbnailURLString != nil) ? URL(string: wikipediaThumbnailURLString!)! : nil
        }
    }
    
    // MARK: Initialization, ResponseObjectSerializable Protocol
    
    init?(dictionary: [String : AnyObject]) {
        guard let title = dictionary[SerializationKeys.LandmarkKey] as? String, let wikipediaSnippet = dictionary[SerializationKeys.WikipediaSnippetKey] as? String, let wikipediaURL = dictionary[SerializationKeys.WikipediaLinkKey] as? String else  {
            return nil
        }
        
        self.title = title
        self.wikipediaSnippet = wikipediaSnippet
        self.wikipediaURLString = wikipediaURL
        
        if let wikipediaThumbnail = dictionary[SerializationKeys.WikipediaThumbnailLinkKey] as? String {
            self.wikipediaThumbnailURLString = wikipediaThumbnail
        }
    }
}

extension Landmark: CustomStringConvertible {
    var description: String {
        return  "\(type(of: self)) \(self.title), \(self.wikipediaSnippet), \(self.wikipediaURL), \(self.wikipediaThumbnail)\n" }

}

