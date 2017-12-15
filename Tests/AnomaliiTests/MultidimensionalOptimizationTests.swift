//
//  MultidimensionalOptimizationTests.swift
//  AnomaliiTests
//
//  Attempts to create an optimizer trained on Rosenbrock function, which is
//  notoriously difficult to optimize. https://en.wikipedia.org/wiki/Rosenbrock_function
//
//  Created by Drew McCormack on 15/12/2017.
//

import XCTest
import Anomalii

class MultidimensionalOptimizationTests: XCTestCase, FitnessEvaluator {
    
    var startingPoints: [[Double]]!
    
    var solver: Solver!
    
    override func setUp() {
        super.setUp()
        
        startingPoints = [[Double]]()
        for _ in 0..<20 {
            let point = [(-1.0...1.0).random, (-1.0...1.0).random]
            startingPoints.append(point)
        }
        
        var config = Solver.Configuration()
        config.populationComponents.constantTypes = [ScalarConstant.self, VectorConstant.self]
        config.populationComponents.variables = [VectorVariable(named: "grad")]
        config.populationComponents.memberValueKind = .vector
        config.populationComponents.vectorLength = 2
        config.populationComponents.operatorTypes = [DotProduct.self, VectorAddition.self, ScalarVectorMultiplication.self, ScalarAddition.self, ScalarMultiplication.self]
        config.populationMetrics.maximumDepth = 8
        config.populationMetrics.populationSize = 50
        
        solver = Solver(configuration: config, fitnessEvaluator: self)
    }
    
    func testEvolution() {
        solver.evolve(generations: 100)
//        let winner = solver.bestCandidate
//        let values = x.map { winner.evaluated(for: ["x":Value.vector($0)]) }
//        for case let (yValue, .scalar(winnerY)) in zip(y, values) {
//            XCTAssertEqual(winnerY, yValue, accuracy: 2.0)
//        }
    }

    func fitness(of expression: Expression) -> Double {
        let sumOfErrorSquares = startingPoints.reduce(0.0) { (sum, point) in
            if case let .vector(step) = expression.evaluated(for: ["x":.vector(point)]) {
                let targetStep = point.map { -$0 } // Minimum is at (0,0)
                let part = zip(step, targetStep).reduce(0.0) { sum, pair in
                    let diff = (pair.0 - pair.1)
                    return sum + diff * diff
                }
                return sum + part
            } else {
                fatalError()
            }
        }
        return 1.0 / max(1.0e-8, sumOfErrorSquares)
    }

    /// Function is (a-x1)^2+b(x2-x1^2)^2
    /// The minimum is at (1,1)
    func rosenbrock(_ x: [Double]) -> Double {
        precondition(x.count == 2)
        let a = 1.0
        let b = 100.0
        let aMinX = a - x[0]
        let yMinXSquared = x[1] - x[0]*x[0]
        return aMinX * aMinX + b * yMinXSquared * yMinXSquared
    }

}
