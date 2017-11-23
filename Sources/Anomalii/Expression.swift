//
//  Expression.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

struct ExpressionConstraints {
    let constantRange: ClosedRange<Double>
}

protocol Expression {
    static var outputType: Value.Kind { get }
    static var arity: Int { get }
    var isValid: Bool { get }
    var depth: Int { get }
    func evaluated(for valuesByString: [String:Value]) -> Value
    func transformed(where condition: ((Expression)->Bool)?, by transformer: (Expression)->Expression) -> Expression
    func traverse(where condition: ((Expression)->Bool)?, visitWith visiter: (Expression)->Void)
    func count(where condition: ((Expression)->Bool)?) -> Int
    func isSame(as other: Expression) -> Bool
}

