//
//  Solver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

public struct PopulationComponents {
    public var operatorTypes: [Operator.Type] = [ScalarAddition.self, ScalarMultiplication.self]
    public var constantTypes: [Constant.Type] = [ScalarConstant.self]
    public var variables: [Variable] = [ScalarVariable(named: "x")]
    public var memberValueKind: Value.Kind = .scalar
    public var constantRange: ClosedRange<Double> = -10...10
    public var vectorLength: Int = 1
    public init() {}
}

public class Solver {
    public struct Configuration {
        public var populationComponents: PopulationComponents = PopulationComponents()
        public var populationMetrics = Populator.Metrics()
        public init() {}
    }
    
    public let configuration: Configuration
    public let fitnessEvaluator: FitnessEvaluator
    public let initialPopulation: [Expression]
    
    public var population: [Expression] { return evolver.population }
    public var bestCandidate: Expression {
        return evolver.fitnessResults().max(by: { $0.fitness < $1.fitness })!.expression
    }

    private let populator: Populator
    private let mutator: StandardMutator
    private let evolver: Evolver

    public init(configuration: Configuration, fitnessEvaluator: FitnessEvaluator) {
        self.configuration = configuration
        self.fitnessEvaluator = fitnessEvaluator
        self.mutator = StandardMutator(populationComponents: configuration.populationComponents)
        self.populator = Populator(withMetrics: configuration.populationMetrics, components: configuration.populationComponents)
        self.initialPopulation = populator.makePopulation()
        self.evolver = Evolver(initialPopulation: initialPopulation, evaluatingFitnessWith: fitnessEvaluator, mutatingWith: mutator)
    }
    
    public func evolve(generations: Int) {
        (0..<generations).forEach { _ in evolver.evolve() }
    }
}
