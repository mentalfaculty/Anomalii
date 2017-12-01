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
    
    struct FitnessResult: Hashable {
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
        let fitnessResults = self.fitnessResults()
        
        // Elitism: the best 1% go direct to the new population
        var elitismCandidates = fitnessResults.sorted { $0.fitness > $1.fitness } // Best first
        let numberElites = populationSize.portioned(percentage: 1)
        let eliteResults = elitismCandidates[0..<numberElites]
        elitismCandidates.removeFirst(numberElites)
        newPopulation += eliteResults.map { $0.expression }
        
        // Semi-Elite: 8% from the remainder are randomly selected (weighted by fitness)
        let numberSemiElites = populationSize.portioned(percentage: 8)
        for _ in 0..<numberSemiElites {
            let (result, index) = elitismCandidates.fitnessWeightedRandomResult()
            elitismCandidates.remove(at: index)
            newPopulation.append(result.expression)
        }
        
        // Crossover is used for 90%. We do tournaments of 3 randomly chosen contestants for each tournament.
        let tournamentSize = 3
        let numberCrossover = populationSize.portioned(percentage: 90)
        for _ in 0..<numberCrossover {
            let firstWinner = fitnessResults.random(choosing: tournamentSize).max(by:{ $0.fitness < $1.fitness })!.expression
            let secondWinner = fitnessResults.random(choosing: tournamentSize).max(by:{ $0.fitness < $1.fitness })!.expression
            let crossedExpression = mutator.expression(crossing: firstWinner, with: secondWinner)
            newPopulation.append(crossedExpression)
        }
        
        // Remainder get mutated
        let numberOfMutated = populationSize - numberElites - numberSemiElites - numberCrossover
        for _ in 0..<numberOfMutated {
            let winner = fitnessResults.random(choosing: tournamentSize).max(by:{ $0.fitness < $1.fitness })!.expression
            let mutatedExpression = mutator.expression(mutating: winner)
            newPopulation.append(mutatedExpression)
        }
        
        population = newPopulation
    }
    
    func fitnessResults() -> [FitnessResult] {
        return population.enumerated().map { (index, expression) in
            return FitnessResult(populationIndex: index, expression: expression, fitness: fitnessEvaluator.fitness(of: expression))
        }
    }
}

extension Int {
    func portioned(percentage: Double) -> Int {
        return Int(Double(self) * percentage / 100.0)
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
