//
//  Solver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

public class Solver {
    public struct Configuration {
        public var variableNames = ["x"]
        public var constraintsForRandomExpressions = ExpressionConstraints(constantRange: -10...10)
        public var populatorConstraints = Populator.Constraints()
        public init() {}
    }
    
    public let configuration: Configuration
    public let fitnessEvaluator: FitnessEvaluator
    public let variables: [Variable]
    public let initialPopulation: [Expression]
    
    public var population: [Expression] { return evolver.population }
    public var bestCandidate: Expression {
        return evolver.fitnessResults().max(by: { $0.fitness < $1.fitness })!.expression
    }

    private let populator: Populator
    private let mutator: StandardMutator
    private let evolver: Evolver

    public init(configuration: Configuration, fitnessEvaluator: FitnessEvaluator) {
        self.variables = configuration.variableNames.map({ Variable(named: $0) })
        self.configuration = configuration
        self.fitnessEvaluator = fitnessEvaluator
        self.mutator = StandardMutator(variables: variables)
        self.populator = Populator(withConstraints: configuration.populatorConstraints, variables: variables)
        self.initialPopulation = populator.makePopulation()
        self.evolver = Evolver(initialPopulation: initialPopulation, evaluatingFitnessWith: fitnessEvaluator, mutatingWith: mutator)
    }
    
    public func evolve(generations: Int) {
        (0..<generations).forEach { _ in evolver.evolve() }
    }
}
