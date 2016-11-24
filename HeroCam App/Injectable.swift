//
//  Injectable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

/**
 *  Dependency injection is a software design pattern that implements Inversion of Control for resolving dependencies. Following thi pattern, ```Injectable```  protocol helps the app split into loosely-coupled components, which can be developed, tested and maintained more easily. A component that needs to be injected with a value, implements the protocol and we must check after initialization that the dependecies are in place, using the ```assertDependencies()``` function.
 */
protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}
