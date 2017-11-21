//
//  Operator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Operator: Expression {
    static var inputTypes: [Value.Kind] { get }
    var children: [Expression] { get set }
    init(withChildren children: [Expression])
}

extension Operator {
    static var arity: Int { return inputTypes.count }
    
    var depth: Int {
        return 1 + children.reduce(0) { max($1.depth, $0) }
    }
    
    func traverse(where condition: ((Expression)->Bool)? = nil, visitWith visiter: (Expression)->Void) {
        children.forEach { $0.traverse(where: condition, visitWith: visiter) }
        if (condition?(self) ?? true) { visiter(self) }
    }
    
    func transformed(where condition: ((Expression)->Bool)? = nil, by transformer: (Expression)->Expression) -> Expression {
        var newSelf = self
        let newChildren = children.map { $0.transformed(where: condition, by: transformer) }
        newSelf.children = newChildren
        return (condition?(self) ?? true) ? transformer(newSelf) : newSelf
    }
    
    var isValid: Bool {
        return children.enumerated().reduce(true) { result, indexChild in
            return result && type(of: indexChild.1).outputType == Self.inputTypes[indexChild.0]
        }
    }
}

protocol BinaryOperator: Operator {
}
