//
//  Solver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

class Solver: Mutator, FitnessEvaluator {
    let initialPopulation: [Expression]
    let constraintsForRandomExpressions = ExpressionConstraints(constantRange: -10...10)
    
    lazy var evolver: Evolver = {
        return Evolver(initialPopulation: initialPopulation, evaluatingFitnessWith: self, mutatingWith: self)
    }()
    
    init() {
        initialPopulation = [Expression]()
    }
    
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression {
        return expression1
    }
    
    func expression(mutating expression: Expression) -> Expression {
        return expression
    }
    
    func fitness(of expression: Expression) -> Double {
        return 1.0
    }
}
