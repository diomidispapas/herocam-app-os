//
//  NSMutableData+SKAdditions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/11/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
