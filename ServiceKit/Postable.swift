//
//  Postable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

public protocol Postable {
    associatedtype U
    func post(_ request: Request, completionHandler: @escaping (Failable<U, NetworkError >) -> Void)
}
