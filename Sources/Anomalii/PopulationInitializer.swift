//
//  PopulationInitializer.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

struct InitialPopulationConstraints {
    let populationSize: Int
    let maximumDepth: Int
}

class PopulationInitializer {
    let constraints: InitialPopulationConstraints
    let variables: [Variable]
    private let expressionMaker: ExpressionMaker
    
    init(withConstaints constraints: InitialPopulationConstraints, variables: [Variable]) {
        self.constraints = constraints
        self.variables = variables
        self.expressionMaker = ExpressionMaker(variables: variables, maximumDepth: constraints.maximumDepth)
    }
    
    func makeInitialPopulation() -> [Expression] {
        var population = [Expression]()
        for _ in 0..<constraints.populationSize {
            let expression = expressionMaker.expression(withOutputType: .scalar)
            population.append(expression)
        }
        return population
    }
}
