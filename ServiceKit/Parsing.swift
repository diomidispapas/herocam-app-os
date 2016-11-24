//
//  Parsing.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

//MARK: Parsing
public protocol Parsing {
    associatedtype ParsableType
    func parseData(_ data: Data) throws -> ParsableType?
}

public enum ParsingError: Error {
    case error(NSError)
}

//MARK: String Parsing
/**
 *  StringParsing protocol & protocol extension that parses ```NSData``` to ```NSString```. The protocol is unused in our case, but it has been included as a demonstration of protocol inheritance.
 */
public protocol StringParsing: Parsing { }
extension StringParsing {
    func parseData(_ data: Data) -> String? {
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

//MARK: JSON Parsing
public protocol JSONParsing: Parsing {
    associatedtype ParsableType = [String:AnyObject]
}
extension JSONParsing {
    public func parseData(_ data: Data) throws -> ParsableType? {
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! [String: AnyObject] as AnyObject!
            return parsedResult as? ParsableType
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            throw ParsingError.error(NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
}

//MARK: Image Parsing
public protocol ImageParsing: Parsing {
    associatedtype ParsableType = UIImage
}
extension ImageParsing {
    public func parseData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
