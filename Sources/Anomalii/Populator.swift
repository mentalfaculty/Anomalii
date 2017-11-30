//
//  Populator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

class Populator {
    struct Constraints {
        var populationSize: Int = 500
        var maximumDepth: Int = 10
    }
    
    let constraints: Constraints
    let variables: [Variable]
    private let orator: Orator
    
    init(withConstraints constraints: Constraints, variables: [Variable]) {
        self.constraints = constraints
        self.variables = variables
        self.orator = Orator(variables: variables, maximumDepth: constraints.maximumDepth)
    }
    
    func makePopulation() -> [Expression] {
        var population = [Expression]()
        for _ in 0..<constraints.populationSize {
            let expression = orator.expression(withOutputType: .scalar)
            population.append(expression)
        }
        return population
    }
}
