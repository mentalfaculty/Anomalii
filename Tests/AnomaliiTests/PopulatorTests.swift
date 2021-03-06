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
        let metrics = Populator.Metrics(populationSize: 10, maximumDepth: 5)
        var components = PopulationComponents()
        components.variables = [ScalarVariable(named: "x")]
        populator = Populator(withMetrics: metrics, components: components)
    }
    
    func testDepth() {
        let p = populator.makePopulation()
        XCTAssertEqual(p.filter({ $0.depth != 5 }).count, 0)
    }
    
    func testSize() {
        XCTAssertEqual(populator.makePopulation().count, 10)
    }
    
}
