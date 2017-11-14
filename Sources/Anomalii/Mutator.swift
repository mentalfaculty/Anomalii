//
//  Mutator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Mutator: class {
    func expression(byMutating expression: Expression) -> Expression
    func expression(byCrossing expression1: Expression, with expression2: Expression) -> Expression
}

class StandardMutator: Mutator {
    let variables: [Variable]
    
    init(variables: [Variable]) {
        self.variables = variables
    }
    
    func expression(byMutating expression: Expression) -> Expression {
        // Implement as a cross with a random expression
        let expressionMaker = ExpressionMaker(variables: variables, maximumDepth: expression.depth)
        let other = expressionMaker.expression(withOutputType: .scalar)
        return expression(byCrossing: expression, with: other)
    }
    
    func expression(byCrossing expression1: Expression, with expression2: Expression) -> Expression {
        // Choose random node index
        let indexToCross1 = indexOfRandomNode(in: expression1)
        let indexToCross2 = indexOfRandomNode(in: expression2)
        
        // Mutate that node
        var index = 0
        let newExpression = expression.transformed { e in
            if isChosenType(expression: e) {
                let mutate = index == indexToMutate
                index += 1
                if mutate {
                    expressionMaker.maximumDepth = (0...maximumDepthForNewExpressions).random
                    return expressionMaker.expression(withOutputType: .scalar)
                }
            }
            return e
        }
        
        return newExpression
    }
    
    private func indexOfRandomNode(in expression: Expression) -> Int {
        var numberNodes = 0
        while numberOfNodes == 0 {
            let mutateLeaf = (0.0...1.0).random > 0.9 // 10% leaf mutation
            func isChosenType(expression: Expression) -> Bool {
                if mutateLeaf {
                    return expression is Terminal
                } else {
                    return expression is Operator
                }
            }
            
            // Count leaves
            numberNodes = 0
            expression.traverse { numberNodes += isChosenType(expression: $0) ? 1 : 0 }
        }
        return (0...numberNodes-1).random
    }
    
}
