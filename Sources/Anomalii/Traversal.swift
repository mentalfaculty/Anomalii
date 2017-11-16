//
//  Traversal.swift
//  Anomalii
//
//  Created by Drew McCormack on 16/11/2017.
//

import Foundation

struct TraversalIndex {
    var index: Int
    var visitCondition: ((Expression)->Bool)?
    
    init(index: Int, visitCondition: ((Expression)->Bool)? = nil) {
        self.index = index
        self.visitCondition = visitCondition
    }
}

extension Expression {
    
    func count(where condition: ((Expression)->Bool)?) -> Int {
        var numberNodes = 0
        traverse(where: condition) { _ in numberNodes +=  1 }
        return numberNodes
    }
    
    func expression(at traversalIndex: TraversalIndex) -> Expression {
        var index = 0
        var result: Expression?
        traverse(where: traversalIndex.visitCondition) {
            if index == traversalIndex.index { result = $0 }
            index += 1
        }
        return result!
    }
    
    func expression(substituting substitute: Expression, at traversalIndex: TraversalIndex) -> Expression {
        var index = 0
        return transformed(where: traversalIndex.visitCondition) {
            let node = index == traversalIndex.index ? substitute : $0
            index += 1
            return node
        }
    }
}
