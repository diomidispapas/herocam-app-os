//
//  Gettable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

public protocol Gettable {
    associatedtype U
    func get(_ request: Request, completionHandler: @escaping (Failable<U, NetworkError >) -> Void)
}

