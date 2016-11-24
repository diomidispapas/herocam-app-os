//
//  CacheKitTests.swift
//  CacheKitTests
//
//  Created by Diomidis Papas on 10/11/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import CacheKit

class CacheKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleCaching() {
        let testImage = UIImage(named: "test_image.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)
        XCTAssert(testImage != nil, "test failed on line \(#line) in function \(#function)")
        Cache.set(testImage, withIdentifier: "test_image")
        let cachedImage = Cache.get(with: "test_image")
        XCTAssert(cachedImage != nil, "test failed on line \(#line) in function \(#function)")
    }
}
