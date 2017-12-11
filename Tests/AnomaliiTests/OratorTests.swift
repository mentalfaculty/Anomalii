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
        var components = PopulationComponents()
        components.variables = [ScalarVariable(named: "x")]
        orator = Orator(withComponents: components, maximumDepth: 2)
    }
    
    func testOration() {
        let expression = orator.expression(withOutputValueKind: .scalar)
        XCTAssertEqual(expression.depth, 2)
    }
    
}
