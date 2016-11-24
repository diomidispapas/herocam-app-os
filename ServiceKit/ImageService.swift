//
//  ImageService.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

public struct ImageService: Gettable, ImageParsing, RemoteRequestExecutable {
    public typealias U = UIImage
    
    public init() {}
    
    //MARK: Gettable
    public func get(_ request: Request, completionHandler: @escaping (Failable<U, NetworkError>) -> Void) {
        _ = taskForGETImage(URL(string: request.path)!) { (result, error) in
            DispatchQueue.main.async(execute: {
                guard (error == nil) else {
                    completionHandler(.failure(NetworkError.error(error)))
                    return
                }
                
                if let result = result {
                    completionHandler(.success(result))
                } else {
                    completionHandler(.failure(NetworkError.unknownError(nil)))
                }
            })
        }
    }
    
    //MARK: Private
    fileprivate func taskForGETImage(_ imageURL: URL, completionHandler: @escaping (_ imageData: UIImage?, _ error: NSError?) ->  Void) -> URLSessionTask {
        return self.taskForGET(with: imageURL, completionHandler: { (result, error) in
            completionHandler(result as? UIImage, error)
        })
    }
}
