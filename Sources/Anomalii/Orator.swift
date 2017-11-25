//
//  Orator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

/// An expression maker
class Orator {
    var operatorTypes: [Operator.Type] = [ScalarAddition.self, ScalarMultiplication.self]
    var variables: [Variable]
    var maximumDepth: Int
    private var currentDepth = 0
    
    init(variables: [Variable], maximumDepth: Int) {
        self.variables = variables
        self.maximumDepth = maximumDepth
    }
    
    func expression(withOutputType outputType: Value.Kind) -> Expression {
        precondition(outputType == .scalar)
        var e: Expression
        currentDepth += 1
        defer { currentDepth -= 1 }
        if currentDepth < maximumDepth {
            let children = [expression(withOutputType: .scalar), expression(withOutputType: .scalar)]
            let op = operatorTypes.random
            e = op.init(withChildren: children)
        } else {
            switch (0...1).random {
            case 0:
                e = Constant(doubleValue: (-10.0...10.0).random)
            case 1:
                e = variables.random
            default:
                fatalError()
            }
        }
        return e
    }
}
