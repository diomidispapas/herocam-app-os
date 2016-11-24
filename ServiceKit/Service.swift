//
//  Service.swift
//  HeroCam
//
//  Created by Diomidis Papas on 11/24/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

public enum RemoteServiceError: Error {
    case serviceError(NSError?), parsingError
}

public struct Service<T: ResponseObjectSerializable>: Gettable, Postable, JSONParsing, RemoteRequestExecutable {
    
    public init() {}
    
    // MARK: Gettable
    public func get(_ request: Request, completionHandler: @escaping (Failable<T, NetworkError>) -> Void) {
        _ = taskForGET(request: request) { (result, error) in
            DispatchQueue.main.async(execute: {
                guard (error == nil) else {
                    completionHandler(.failure(NetworkError.error(error)))
                    return
                }
                
                if let unwrappedResult = result as? [String : AnyObject], let result = T(dictionary: unwrappedResult) {
                    completionHandler(.success(result))
                } else {
                    completionHandler(.failure(NetworkError.unknownError(nil)))
                }
            })
        }
    }
    
    // MARK: Postable
    public func post(_ request: Request, completionHandler: @escaping (Failable<T, NetworkError>) -> Void) {
        _ = taskForPOST(request) { (result, error) in
            DispatchQueue.main.async(execute: {
                guard (error == nil) else {
                    completionHandler(.failure(NetworkError.error(error)))
                    return
                }
                
                if let unwrappedResult = result as? [String : AnyObject], let result = T(dictionary: unwrappedResult) {
                    completionHandler(.success(result))
                } else {
                    completionHandler(.failure(NetworkError.unknownError(nil)))
                }
            })
        }
    }
    
    //MARK: Private
    fileprivate func taskForPOST(_ request: Request, completionHandler: @escaping (AnyObject?, NSError?) -> Void) -> URLSessionDataTask {
        // 1. Build the URL and configure the request
        let urlString = RequestConstructor.construct(request)
        let url = URL(string: urlString)!
        Log.url(urlString)/
        
        return self.taskForPOSTImage(with: url, parameters: request.parameters, image: request.parameters["image"] as! UIImage, completionHandler: completionHandler)
    }
    
    fileprivate func taskForGET(request: Request, completionHandler: @escaping (AnyObject?, NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Build the URL and configure the request
        let urlString = RequestConstructor.construct(request)
        let url: URL = URL(string: urlString)!
        Log.url(urlString)/
        
        return taskForGET(with: url, completionHandler: completionHandler)
    }
}
