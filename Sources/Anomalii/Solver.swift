//
//  Solver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

class Solver {
    struct Configuration {
        var variableNames = ["x"]
        var constraintsForRandomExpressions = ExpressionConstraints(constantRange: -10...10)
        var populatorConstraints = Populator.Constraints()
    }
    
    let configuration: Configuration
    let fitnessEvaluator: FitnessEvaluator
    let variables: [Variable]
    let initialPopulation: [Expression]
    
    var population: [Expression] { return evolver.population }
    var bestCandidate: Expression {
        return evolver.fitnessResults().max(by: { $0.fitness < $1.fitness })!.expression
    }

    private let populator: Populator
    private let mutator: StandardMutator
    private let evolver: Evolver

    init(configuration: Configuration, fitnessEvaluator: FitnessEvaluator) {
        self.variables = configuration.variableNames.map({ Variable(named: $0) })
        self.configuration = configuration
        self.fitnessEvaluator = fitnessEvaluator
        self.mutator = StandardMutator(variables: variables)
        self.populator = Populator(withConstraints: configuration.populatorConstraints, variables: variables)
        self.initialPopulation = populator.makePopulation()
        self.evolver = Evolver(initialPopulation: initialPopulation, evaluatingFitnessWith: fitnessEvaluator, mutatingWith: mutator)
    }
    
    func evolve(generations: Int) {
        (0..<generations).forEach { _ in evolver.evolve() }
    }
}
