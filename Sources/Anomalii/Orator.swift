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
    
    func expression(withOutputValueKind outputKind: Value.Kind) -> Expression? {
        var e: Expression?
        currentDepth += 1
        defer { currentDepth -= 1 }
        if currentDepth < maximumDepth {
            let candidates = components.operatorTypes.filter { outputKind == $0.outputValueKind }
            guard let op = candidates.random else { return nil }
            let children = op.inputValueKinds.flatMap {
                expression(withOutputValueKind: $0)
            }
            guard children.count == op.inputValueKinds.count else { return nil }
            e = op.init(withChildren: children)
        } else {
            e = repeatedlyAttemptToCreate() {
                switch (0...1).random {
                case 0:
                    let candidates = components.constantTypes.filter { outputKind == $0.outputValueKind }
                    let constantType = candidates.random
                    switch constantType {
                    case is ScalarConstant.Type:
                        return ScalarConstant(randomWithValuesIn: components.constantRange)
                    case is VectorConstant.Type:
                        return VectorConstant(randomWithValuesIn: components.constantRange)
                    default:
                        fatalError()
                    }
                case 1:
                    let candidates = components.variables.filter { outputKind == type(of: $0).outputValueKind }
                    return candidates.random
                default:
                    fatalError()
                }
            }
        }
        return e
    }
}
