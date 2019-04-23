//
//  KNNTests.swift
//  AIDevLogTests
//
//  Created by iosdevlog on 2019/4/6.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import XCTest
import SwiftAI

class KNNTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKNNClassifier() {
        let X = [[1.0], [2], [3], [4]]
        let y = [0.0, 0, 1, 1]
        let kNN = KNNClassifier(k: 3, distanceFunc: euclidean)
        kNN.fit(X: X, y: y)
        
        let label = kNN.predict(XTest: [[1.2], [3]])
        
        XCTAssertEqual([0, 1], label)
    }
    
    func testKNNRegressor() {
        let X = [[1.0], [2], [3], [4]]
        let y = [0.0, 0, 1, 1]
        let kNN = KNNRegressor(k: 3, distanceFunc: euclidean)
        kNN.fit(X: X, y: y)
        
        let predict = kNN.predict(XTest: [[1.2], [3]])
        
        XCTAssertEqual([0.3333333333333333, 0.6666666666666666], predict)
    }

}
