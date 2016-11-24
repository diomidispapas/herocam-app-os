//
//  ServiceKitTestsAdditions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/11/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation
import ServiceKit

struct FakeRequest: Request {
    var baseURL: String { return "https://www.domain.com/" }
    var path : String { return "path" }
    var parameters : [String : AnyObject] { return ["param1":"value1" as AnyObject, "param2":"value2" as AnyObject] }
    var headers : [String : AnyObject] { return [String : AnyObject]() }
}
