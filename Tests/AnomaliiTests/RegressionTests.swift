//
//  RegressionTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 30/11/2017.
//

import XCTest
@testable import Anomalii

class RegressionTests: XCTestCase, FitnessEvaluator {
    
//    func savePopulation(toFile fileURL: URL) throws {
//        let jsonData = try JSONEncoder().encode(population)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
//    }
    
    var x: [Double]!
    var y: [Double]!
    
    var solver: Solver!
    
    override func setUp() {
        super.setUp()
        x = (-5...5).map { Double($0) }
        y = x.map { $0*$0 + $0 + Double.random }
        var config = Solver.Configuration()
        config.populatorConstraints.maximumDepth = 8
        config.populatorConstraints.populationSize = 50
        solver = Solver(configuration: config, fitnessEvaluator: self)
    }
    
    func testEvolution() {
        solver.evolve(generations: 100)
        let winner = solver.bestCandidate
        let values = x.map { winner.evaluated(for: ["x":Value.scalar($0)]) }
        for case let (yValue, .scalar(winnerY)) in zip(y, values) {
            XCTAssertEqual(winnerY, yValue, accuracy: 2.0)
        }
    }
    
    func fitness(of expression: Expression) -> Double {
        let sumOfErrorSquares = zip(x,y).reduce(0.0) { (sum, xy) in
            let (x,y) = xy
            if case let .scalar(expressionY) = expression.evaluated(for: ["x":.scalar(x)]) {
                let diff = y - expressionY
                return sum + diff * diff
            } else {
                fatalError()
            }
        }
        return  1.0 / max(1.0e-8, sumOfErrorSquares)
    }
}
