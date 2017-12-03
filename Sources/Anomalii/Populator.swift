//
//  Populator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

public class Populator {
    
    public struct Constraints {
        public var populationSize: Int
        public var maximumDepth: Int
        
        public init(populationSize: Int = 500, maximumDepth: Int = 10) {
            self.populationSize = populationSize
            self.maximumDepth = maximumDepth
        }
    }
    
    public let constraints: Constraints
    public let variables: [Variable]
    private let orator: Orator
    
    public init(withConstraints constraints: Constraints, variables: [Variable]) {
        self.constraints = constraints
        self.variables = variables
        self.orator = Orator(variables: variables, maximumDepth: constraints.maximumDepth)
    }
    
    public func makePopulation() -> [Expression] {
        var population = [Expression]()
        for _ in 0..<constraints.populationSize {
            let expression = orator.expression(withOutputType: .scalar)
            population.append(expression)
        }
        return population
    }
    
}
