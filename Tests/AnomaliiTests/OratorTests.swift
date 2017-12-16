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
        components.variables = [ScalarVariable(named: "x"), VectorVariable(named: "y")]
        components.constantTypes += [VectorConstant.self]
        components.operatorTypes += [DotProduct.self, VectorAddition.self, ScalarVectorMultiplication.self] as! [Operator.Type]
        orator = Orator(withComponents: components, maximumDepth: 5)
    }
    
    func testOration() {
        let expression = orator.expression(withOutputValueKind: .scalar)
        XCTAssertNotNil(expression)
        XCTAssertEqual(expression!.depth, 5)
    }

    func testValidity() {
        for _ in 0..<10 {
            let expression = orator.expression(withOutputValueKind: .scalar)
            XCTAssertTrue(expression?.isValid ?? false)
            
            let vectorExpression = orator.expression(withOutputValueKind: .vector)
            XCTAssertTrue(vectorExpression?.isValid ?? false)
        }
    }
}
