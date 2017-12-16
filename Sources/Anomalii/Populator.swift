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
    public let components: PopulationComponents
    private let orator: Orator
    
    public init(withMetrics metrics: Metrics, components: PopulationComponents) {
        self.metrics = metrics
        self.components = components
        self.orator = Orator(withComponents: components, maximumDepth: metrics.maximumDepth)
    }
    
    public func makePopulation() -> [Expression] {
        var population = [Expression]()
        while population.count < metrics.populationSize {
            guard let expression = orator.expression(withOutputValueKind: components.memberValueKind) else { continue }
            population.append(expression)
        }
        return population
    }
    
}
