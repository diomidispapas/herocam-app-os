//
//  ServiceKitTests.swift
//  ServiceKitTests
//
//  Created by Diomidis Papas on 10/11/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import ServiceKit

class ServiceKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Service components testing
    
    /**
     Function that tests the **Constructable** protocol by constructing a *FakeRequest*
     */
    func testConstructable() {
        let contructor = RequestConstructor.construct(FakeRequest())
        XCTAssertEqual(contructor, "https://www.domain.com/path?param1=value1&param2=value2")
    }
}
