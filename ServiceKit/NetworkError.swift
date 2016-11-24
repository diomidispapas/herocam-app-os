//
//  NetworkError.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case error(NSError?), unknownError(String?)
}
