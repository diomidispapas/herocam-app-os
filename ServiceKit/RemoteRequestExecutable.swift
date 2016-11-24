//
//  RemoteRequestExecutable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

public protocol RemoteRequestExecutable {
    func taskForGET(with url: URL, completionHandler: @escaping (AnyObject?, NSError?) -> Void) -> URLSessionDataTask
}

extension RemoteRequestExecutable where Self: Parsing {
    public func taskForGET(with url: URL, completionHandler: @escaping (AnyObject?, NSError?) -> Void) -> URLSessionDataTask {
        Log.url(url.absoluteString)/
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            // Error
            guard (error == nil) else {
                Log.error(error! as NSError)/
                completionHandler(nil, error as NSError?)
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                Log.other("No data was returned by the request!")/
                completionHandler(nil, error as NSError?)
                return
            }
            
            // 5. Parse the data
            do {
                let parsedResult = try self.parseData(data)
                completionHandler(parsedResult as AnyObject, nil)
            } catch ParsingError.error(let error) {
                completionHandler(nil, error)
            } catch {
                assertionFailure("Unexpectd error while pasring Data")
            }
        }) 
        task.resume()
        return task
    }
    
    func taskForPOSTImage(with url: URL, parameters: [String : AnyObject], image: UIImage, completionHandler: @escaping (AnyObject?, NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        let boundary = generateBoundaryString()
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters, filePathKey: "photo", imageDataKey: imageData!, boundary: boundary)

        // 2. Make the request
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // Error
            guard (error == nil) else {
                Log.error(error! as NSError)/
                completionHandler(nil, error as NSError?)
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                Log.other("No data was returned by the request!")/
                completionHandler(nil, error as NSError?)
                return
            }
            
            // 5. Parse the data
            do {
                let parsedResult = try self.parseData(data)
                completionHandler(parsedResult as AnyObject, nil)
            } catch ParsingError.error(let error) {
                completionHandler(nil, error)
            } catch {
                assertionFailure("Unexpectd error while pasring Data")
            }
        })
        task.resume()
        return task
    }
    
    /** Private Helper method for creating the body of a multipart/form */
    fileprivate func createBodyWithParameters(_ parameters: [String: AnyObject], filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        
        let body = NSMutableData();
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        let filename = "test_image.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
