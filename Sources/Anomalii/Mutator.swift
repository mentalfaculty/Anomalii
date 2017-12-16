//
//  Mutator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Mutator: class {
    func expression(mutating expression: Expression) -> Expression?
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression?
}

class StandardMutator: Mutator {
    let components: PopulationComponents
    
    init(populationComponents: PopulationComponents) {
        self.components = populationComponents
    }
    
    func expression(mutating expression: Expression) -> Expression? {
        // Implement as a cross with a random expression
        let orator = Orator(withComponents: components, maximumDepth: expression.depth)
        guard let other = orator.expression(withOutputValueKind: components.memberValueKind) else { return nil }
        return self.expression(crossing: expression, with: other)
    }
    
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression? {
        return repeatedlyAttemptToCreate {
            // Choose first subtree
            guard let indexToCross1 = randomTraversalIndex(in: expression1) else { return nil }
            
            // Try to get a second subtree of the same kind
            let subExpression1 = expression1.expression(at: indexToCross1)
            let kind = type(of: subExpression1).outputValueKind
            guard let indexToCross2 = randomTraversalIndex(in: expression2, forOutputKind: kind) else { return nil }
            
            // Substitute the node
            let subExpression2 = expression2.expression(at: indexToCross2)
            return expression1.expression(substituting: subExpression2, at: indexToCross1)
        }
    }
    
    private func randomTraversalIndex(in expression: Expression, forOutputKind outputKind: Value.Kind? = nil) -> TraversalIndex? {
        return repeatedlyAttemptToCreate {
            let mutateLeaf = (0.0...1.0).random > 0.9 // 10% leaf mutation
            func isValidType(expression: Expression) -> Bool {
                guard
                    outputKind == nil ||
                    outputKind == type(of: expression).outputValueKind else {
                    return false
                }
                if mutateLeaf {
                    return expression is Terminal
                } else {
                    return expression is Operator
                }
            }
            
            let nodeCount = expression.count(where: isValidType)
            if nodeCount < 1 { return nil }
            return TraversalIndex(index:(0...nodeCount-1).random, visitCondition: isValidType)
        }
    }
    
}
