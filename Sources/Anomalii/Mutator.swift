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
        let other = orator.expression(withOutputValueKind: components.memberValueKind)
        return self.expression(crossing: expression, with: other)
    }
    
    func expression(crossing expression1: Expression, with expression2: Expression) -> Expression? {
        var attempts = 0
        var result: Expression?
        
        while result == nil, attempts < 10 {
            attempts += 1
            
            // Choose first subtree
            guard let indexToCross1 = randomTraversalIndex(in: expression1) else { continue }
            
            // Try to get a second subtree of the same kind
            let subExpression1 = expression1.expression(at: indexToCross1)
            let kind = type(of: subExpression1).outputValueKind
            guard let indexToCross2 = randomTraversalIndex(in: expression2, forOutputKind: kind) else { continue }
            
            // Substitute the node
            let subExpression2 = expression2.expression(at: indexToCross2)
            result = expression1.expression(substituting: subExpression2, at: indexToCross1)
        }
        
        return result
    }
    
    private func randomTraversalIndex(in expression: Expression, forOutputKind outputKind: Value.Kind? = nil) -> TraversalIndex? {
        var result: TraversalIndex?
        var attempts = 0
        while result == nil, attempts < 10 {
            attempts += 1

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
            if nodeCount < 1 { continue }
            result = TraversalIndex(index:(0...nodeCount-1).random, visitCondition: isValidType)
        }
        
        return result
    }
    
}
