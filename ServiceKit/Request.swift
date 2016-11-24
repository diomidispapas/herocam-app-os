//
//  Request.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

//MARK: Method
public enum Method {
    case get, post
}

//MARK: Request
/**
 ```Request``` protocol & protocol extensions that contains all the needed information that a Netwrok request needs.
 */
public protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String : AnyObject] { get }
    var headers: [String : AnyObject] { get }
    var method: Method { get }
}

public extension Request {
    var baseURL: String { return "http://0.0.0.0:8080/v1/" }
    var path : String { return "" }
    var parameters : [String : AnyObject] { return [String : AnyObject]() }
    var headers : [String : AnyObject] { return [String : AnyObject]() }
    var method: Method { return .get }
}

//MARK: Constructable

/**
 ```Constructable``` protocol & protocol extension that constructs a type that conforms the ```Request``` protocol.
 */
public protocol Constructable {
    static func construct(_ request: Request) -> String
}

extension Constructable {
    public static func construct(_ request: Request) -> String {
        switch request.method {
        case .get: return request.baseURL + request.path + "?\(request.parameters.map{"\($0)=\($1)"}.joined(separator: "&"))"
        case .post: return request.baseURL + request.path
        }
    }
}
public struct RequestConstructor: Constructable { }

//MARK: Photo Request

/**
 ```PostPhotoRequest``` of format ```http:trivitap-tourist-app.herokuapp.com/v1/detect_landmark```
 */
public struct PostPhotoRequest: Request {
    let image: UIImage
    public let parameters: [String : AnyObject]
    public var path: String = { return "detect_landmark" }()
    public var method: Method = { return .post }()
    public init(image: UIImage) {
        self.image = image
        self.parameters = ["image": image]
    }
}

//MARK: Image Request

public struct ImageRequest: Request {
    public let path: String
    public init(imagePath: String) {
        path = imagePath
    }
}
