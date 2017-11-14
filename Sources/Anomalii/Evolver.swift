//
//  Evolver.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

protocol FitnessEvaluator: class {
    func fitness(of epxression: Expression) -> Double
}

class Evolver {
    
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
        var sortedResults = fitnessResults.sorted { $0.fitness > $1.fitness } // Best first
        
        // Elitism: the best 1% go direct to the new population
        let numberElites = Int(Double(populationSize) * 0.01)
        let eliteResults = sortedResults[0..<numberElites]
        newPopulation += eliteResults.map { $0.expression }
        sortedResults.removeFirst(eliteResults.count)
        
        // Semi-Elite: 18% from the remainder are randomly selected (weighted by fitness)
        let numberSemiElites = Int(Double(populationSize) * 0.18)
        for _ in 0..<numberSemiElites {
            let (result, index) = sortedResults.fitnessWeightedRandomResult()
            newPopulation.append(result.expression)
            sortedResults.remove(at: index)
        }
        
        // From the remaining, use crossover for 80%
        let numberCrossover = (Int(Double(sortedResults.count) * 0.8) / 2) * 2 // Even
        for _ in 0..<numberCrossover/2 {
            let (result1, i1) = sortedResults.fitnessWeightedRandomResult()
            sortedResults.remove(at: i1)
            let (result2, i2) = sortedResults.fitnessWeightedRandomResult()
            sortedResults.remove(at: i2)
            newPopulation += mutator.expression(byCrossing: result1.expression, with: result2.expression)
        }
        
        // Remainder get mutated
        for result in sortedResults {
            let newExpression = mutator.expression(byMutating: result.expression)
            newPopulation.append(newExpression)
        }
        
        population = newPopulation
    }
    
    fileprivate struct FitnessResult: Hashable {
        let populationIndex: Int
        let expression: Expression
        let fitness: Double
        var hashValue: Int { return populationIndex.hashValue }
        static func ==(left: FitnessResult, right: FitnessResult) -> Bool { return left.populationIndex == right.populationIndex }
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
