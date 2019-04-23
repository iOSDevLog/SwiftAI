//
//  SwiftAI.swift
//  AIDevLogTests
//
//  Created by iosdevlog on 2019/4/6.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import XCTest
@testable import SwiftAI

class TestEstimator: BaseEstimator {
    @objc var count: Int
    @objc var desc: String
    
    override init() {
        self.count = 0
        self.desc = "Hello AIDevLog"
        
        super.init()
    }
    
    init(count: Int, desc: String) {
        self.count = count
        self.desc = desc
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class BaseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBaseEstimator() {
        let testEstimator = TestEstimator()
        testEstimator.setParams(params: ["count": 1, "desc": "Hello AIDevLog"])
        let str = testEstimator.getParams(deep: false)
        XCTAssertTrue(str.contains("Hello AIDevLog"))
    }
}
