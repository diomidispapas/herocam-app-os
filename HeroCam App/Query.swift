//
//  Query.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 30/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

struct Query {
    let image: UIImage
}

extension Query: CustomStringConvertible {
    var description: String {
        return  "\(type(of: self)) \(self.image)\n" }
}
