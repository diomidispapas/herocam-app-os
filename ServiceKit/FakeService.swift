//
//  FakeService.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

public protocol FakeResponse {
    var filepath: String { get }
}

public struct FakeService<T: ResponseObjectSerializable>: Gettable, Postable, FakeResponse {
    
    // MARK: FakeResponse
    
    public var filepath: String
    public init(responseFilepath filepath: String) {
        self.filepath = filepath
    }
    
    // MARK: Gettable
    
    public func get(_ request: Request, completionHandler: @escaping (Failable<T, NetworkError>) -> Void) {
        do {
            let dictionary = try FileReader().readJSON(filepath)
            if let dictionary = dictionary, let product = T(dictionary: dictionary) {
                completionHandler(.success(product))
            }
        } catch {
            assert(false, "An error occured while reading file")
        }
    }
    
    // MARK: Postable
    
    public func post(_ request: Request, completionHandler: @escaping (Failable<T, NetworkError >) -> Void) {
        do {
            let dictionary = try FileReader().readJSON(filepath)
            if let dictionary = dictionary, let product = T(dictionary: dictionary) {
                completionHandler(.success(product))
            }
        } catch {
            assert(false, "An error occured while reading file")
        }
    }
}

// MARK: File Reader

public enum FileError: Error {
    case notFound(String), corruptData(String), corruptJSON(String)
}

public struct FileReader: JSONParsing {
    func readJSON(_ filename: String) throws -> [String:AnyObject]? {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: filename, ofType: "json") {
            do {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    return try parseData(data)
                } else {
                    throw FileError.corruptJSON("could not get data from \(filename), make sure that file contains valid json.")
                }
            } catch let error as NSError {
                throw FileError.corruptData("could not get data from \(filename), make sure that file contains valid json. Error: \(error.localizedDescription)")
            }
        } else {
            throw FileError.notFound("could find file with \(filename), make sure that file exists in the bundle.")
        }
    }
}
