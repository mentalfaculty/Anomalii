//
//  Populator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

public class Populator {
    
    public struct Metrics {
        public var populationSize: Int
        public var maximumDepth: Int
        
        public init(populationSize: Int = 500, maximumDepth: Int = 10) {
            self.populationSize = populationSize
            self.maximumDepth = maximumDepth
        }
    }
    
    public let metrics: Metrics
    public let variables: [Variable]
    private let orator: Orator
    
    public init(withMetrics metrics: Metrics, variables: [Variable]) {
        self.metrics = metrics
        self.variables = variables
        self.orator = Orator(variables: variables, maximumDepth: metrics.maximumDepth)
    }
    
    public func makePopulation() -> [Expression] {
        var population = [Expression]()
        for _ in 0..<metrics.populationSize {
            let expression = orator.expression(withOutputType: .scalar)
            population.append(expression)
        }
        return population
    }
    
}
