//
//  Operator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

enum OperatorCodingKey: String, CodingKey {
    case children
}

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
    
    init(from decoder: Decoder) throws {
        self.init(withChildren: [])
        let values = try decoder.container(keyedBy: OperatorCodingKey.self)
        let anyChildren = try values.decode([AnyExpression].self, forKey: .children)
        children = anyChildren.map { $0.expression }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: OperatorCodingKey.self)
        let anyChildren = children.map { AnyExpression($0) }
        try container.encode(anyChildren, forKey: .children)
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
    
    func isSame(as other: Expression) -> Bool {
        guard let otherOperator = other as? Self else { return false }
        return zip(children, otherOperator.children).reduce(true) { (result, pair) in
            return result && pair.0.isSame(as: pair.1)
        }
    }
}

protocol BinaryOperator: Operator {
}
