//
//  Orator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

/// An expression maker
class Orator {
    let components: PopulationComponents
    var maximumDepth: Int
    private var currentDepth = 0
    
    init(withComponents components: PopulationComponents, maximumDepth: Int) {
        self.components = components
        self.maximumDepth = maximumDepth
    }
    
    func expression(withOutputValueKind outputKind: Value.Kind) -> Expression {
        var e: Expression
        currentDepth += 1
        defer { currentDepth -= 1 }
        if currentDepth < maximumDepth {
            let candidates = components.operatorTypes.filter { outputKind == $0.outputType }
            let op = candidates.random
            let children = op.inputTypes.map {
                expression(withOutputValueKind: $0)
            }
            e = op.init(withChildren: children)
        } else {
            switch (0...1).random {
            case 0:
                let candidates = components.constantTypes.filter { outputKind == $0.outputType }
                let constantType = candidates.random
                switch constantType {
                case is ScalarConstant.Type:
                    e = ScalarConstant(randomWithValuesIn: components.constantRange)
                case is VectorConstant.Type:
                    e = VectorConstant(randomWithValuesIn: components.constantRange, length: components.vectorLength)
                default:
                    fatalError()
                }
            case 1:
                e = components.variables.random
            default:
                fatalError()
            }
        }
        return e
    }
}
