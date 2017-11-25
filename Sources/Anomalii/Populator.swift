//
//  Populator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

class Populator {
    struct Constraints {
        let populationSize: Int
        let maximumDepth: Int
    }
    
    let constraints: Constraints
    let variables: [Variable]
    private let expressionMaker: ExpressionMaker
    
    init(withConstaints constraints: Constraints, variables: [Variable]) {
        self.constraints = constraints
        self.variables = variables
        self.expressionMaker = ExpressionMaker(variables: variables, maximumDepth: constraints.maximumDepth)
    }
    
    func makePopulation() -> [Expression] {
        var population = [Expression]()
        for _ in 0..<constraints.populationSize {
            let expression = expressionMaker.expression(withOutputType: .scalar)
            population.append(expression)
        }
        return population
    }
}
