//
//  PopulatorTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 26/11/2017.
//

import XCTest
@testable import Anomalii

class PopulatorTests: XCTestCase {
    
    var populator: Populator!
    
    override func setUp() {
        super.setUp()
        let constraints = Populator.Constraints(populationSize: 10, maximumDepth: 5)
        populator = Populator(withConstaints: constraints, variables: [Variable(named: "x")])
    }
    
    func testDepth() {
        let p = populator.makePopulation()
        XCTAssertEqual(p.filter({ $0.depth != 5 }).count, 0)
    }
    
    func testSize() {
        XCTAssertEqual(populator.makePopulation().count, 10)
    }
    
}
