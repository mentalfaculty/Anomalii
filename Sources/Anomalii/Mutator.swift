//
//  Mutator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Mutator: class {
    func expression(mutating expression: Expression) -> Expression
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression
}

class StandardMutator: Mutator {
    let variables: [Variable]
    
    init(variables: [Variable]) {
        self.variables = variables
    }
    
    func expression(mutating expression: Expression) -> Expression {
        // Implement as a cross with a random expression
        let orator = Orator(variables: variables, maximumDepth: expression.depth)
        let other = orator.expression(withOutputType: .scalar)
        return self.expression(crossing: expression, with: other)
    }
    
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression {
        // Choose random subtrees
        let indexToCross1 = randomTraversalIndex(in: expression1)
        let indexToCross2 = randomTraversalIndex(in: expression2)
        let subExpression2 = expression2.expression(at: indexToCross2)
        
        // Substitute the node
        return expression1.expression(substituting: subExpression2, at: indexToCross1)
    }
    
    private func randomTraversalIndex(in expression: Expression) -> TraversalIndex {
        var nodeCount = 0
        var result: TraversalIndex?
        while result == nil {
            let mutateLeaf = (0.0...1.0).random > 0.9 // 10% leaf mutation
            func isChosenType(expression: Expression) -> Bool {
                if mutateLeaf {
                    return expression is Terminal
                } else {
                    return expression is Operator
                }
            }
            nodeCount = expression.count(where: isChosenType)
            result = TraversalIndex(index:(0...nodeCount-1).random, visitCondition: isChosenType)
        }
        return result!
    }
    
}
