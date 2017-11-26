//
//  Evolver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

protocol FitnessEvaluator: class {
    func fitness(of expression: Expression) -> Double
}

class Evolver {
    
    fileprivate struct FitnessResult: Hashable {
        let populationIndex: Int
        let expression: Expression
        let fitness: Double
        var hashValue: Int { return populationIndex.hashValue }
        static func ==(left: FitnessResult, right: FitnessResult) -> Bool { return left.populationIndex == right.populationIndex }
    }
    
    var population: [Expression]
    weak var fitnessEvaluator: FitnessEvaluator!
    weak var mutator: Mutator!
    
    init(initialPopulation: [Expression], evaluatingFitnessWith evaluator: FitnessEvaluator, mutatingWith mutator: Mutator) {
        self.population = initialPopulation
        self.fitnessEvaluator = evaluator
        self.mutator = mutator
    }
    
    func evolve() {
        let populationSize = population.count
        var newPopulation: [Expression] = []
        
        // Calculate fitnesses
        let fitnessResults = population.enumerated().map { (index, expression) in
            return FitnessResult(populationIndex: index, expression: expression, fitness: fitnessEvaluator.fitness(of: expression))
        }
        var elitismCandidates = fitnessResults.sorted { $0.fitness > $1.fitness } // Best first
        
        // Elitism: the best 1% go direct to the new population
        let numberElites = Int(ceil(Double(populationSize) * 0.01))
        let eliteResults = elitismCandidates[0..<numberElites]
        elitismCandidates.removeFirst(numberElites)
        newPopulation += eliteResults.map { $0.expression }
        
        // Semi-Elite: 4% from the remainder are randomly selected (weighted by fitness)
        let numberSemiElites = Int(Double(populationSize) * 0.08)
        for _ in 0..<numberSemiElites {
            let (result, index) = elitismCandidates.fitnessWeightedRandomResult()
            newPopulation.append(result.expression)
        }
        
        // Crossover is used for 90%
        let numberCrossover = Int(Double(populationSize) * 0.90)
        for _ in numberCrossover {
            let crossedExpression = mutator.expression(crossing: result1.expression, with: result2.expression)
            newPopulation.append(crossedExpression)
        }
        
        // Remainder get mutated
        for result in sortedResults {
            let newExpression = mutator.expression(mutating: result.expression)
            newPopulation.append(newExpression)
        }
        
        population = newPopulation
    }
}

extension Array where Element == Evolver.FitnessResult {
    func fitnessWeightedRandomResult() -> (Evolver.FitnessResult, Int) {
        let total: Double = self.reduce(0.0) { $0 + $1.fitness }
        let rand = Double.random * total
        var sum = 0.0
        for (index, result) in self.enumerated() {
            sum += result.fitness
            if sum >= rand {
                return (result, index)
            }
        }
        return (self.last!, self.count-1)
    }
}
