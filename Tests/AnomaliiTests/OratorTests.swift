//
//  OratorTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 25/11/2017.
//

import XCTest
@testable import Anomalii

class OratorTests: XCTestCase {
    
    var orator: Orator!
    
    override func setUp() {
        super.setUp()
        orator = Orator(variables: [Variable(named: "x")], maximumDepth: 2)
    }
    
    func testOration() {
        let expression = orator.expression(withOutputType: .scalar)
        XCTAssertEqual(expression.depth, 2)
    }
    
}
