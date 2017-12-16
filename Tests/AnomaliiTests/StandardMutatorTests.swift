//
//  StandardMutatorTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 26/11/2017.
//

import XCTest
@testable import Anomalii

class StandardMutatorTests: XCTestCase {
    
    var mutator: StandardMutator!
    var e1, e2: Expression!
    
    override func setUp() {
        super.setUp()
        
        var components = PopulationComponents()
        components.variables = [ScalarVariable(named: "x"), VectorVariable(named: "y")]
        components.constantTypes += [VectorConstant.self]
        components.operatorTypes += [DotProduct.self, VectorAddition.self, ScalarVectorMultiplication.self] as! [Operator.Type]
        mutator = StandardMutator(populationComponents: components)
        
        let sub1 = ScalarAddition(withChildren: [ScalarConstant(doubleValue: 10), ScalarConstant(doubleValue: 5)])
        e1 = ScalarAddition(withChildren: [sub1, ScalarConstant(doubleValue: 4)])
        e2 = ScalarAddition(withChildren: [DotProduct(withChildren: [VectorVariable(named: "y"), VectorConstant(elementValue: 1.0)]), ScalarConstant(doubleValue: 3)])
    }
    
    func testCrossing() {
        var noCrossing = true
        for _ in 0..<10 {
            let crossed = mutator.expression(crossing: e1, with: e2)!
            noCrossing = noCrossing && (e1.isSame(as: crossed) || e2.isSame(as: crossed))
            XCTAssertTrue(crossed.isValid)
        }
        XCTAssertFalse(noCrossing)
    }

    func testMutating() {
        for _ in 0..<10 {
            let mutated = mutator.expression(mutating: e1)!
            XCTAssertLessThanOrEqual(mutated.depth, 6)
            XCTAssertFalse(e1.isSame(as: mutated))
            XCTAssertTrue(mutated.isValid)
        }
    }
}
