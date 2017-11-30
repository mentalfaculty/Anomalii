//
//  StandardMutatorTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 26/11/2017.
//

import XCTest
@testable import Anomalii

class StandardMutatorTests: XCTestCase {
    
    let mutator = StandardMutator(variables: [Variable(named: "x")])
    var e1, e2: Expression!
    
    override func setUp() {
        super.setUp()
        
        let sub1 = ScalarAddition(withChildren: [Constant(doubleValue: 10), Constant(doubleValue: 5)])
        e1 = ScalarAddition(withChildren: [sub1, Constant(doubleValue: 4)])
        e2 = ScalarAddition(withChildren: [Constant(doubleValue: 2), Constant(doubleValue: 3)])
    }
    
    func testCrossing() {
        let crossed = mutator.expression(crossing: e1, with: e2)
        XCTAssertLessThanOrEqual(crossed.depth, 4)
        XCTAssertFalse(e1.isSame(as: crossed) && e2.isSame(as: crossed))
    }

    func testMutating() {
        let mutated = mutator.expression(mutating: e1)
        XCTAssertLessThanOrEqual(mutated.depth, 6)
        XCTAssertFalse(e1.isSame(as: mutated))
    }
}