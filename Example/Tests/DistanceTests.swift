//
//  DistanceTests.swift
//  SwiftAI_Tests
//
//  Created by developer on 4/23/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftAI

class DistanceTests: XCTestCase {

    let v = [-3.0, 4.0]

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1Norm() {
        XCTAssertEqual(7.0, norm(array: v, ord: 1))
    }

    func test2Norm() {
        XCTAssertEqual(5.0, norm(array: v, ord: 2))
    }

}
