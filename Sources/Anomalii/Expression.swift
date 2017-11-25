//
//  Expression.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

struct ExpressionConstraints {
    let constantRange: ClosedRange<Double>
}

protocol Expression: Codable {
    static var codingKey: String { get }
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

struct AnyExpression: Codable {
    var expression: Expression
    
    init(_ expression: Expression) {
        self.expression = expression
    }
    
    private enum Key: CodingKey {
        case type, expression
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let typeKey = try container.decode(String.self, forKey: .type)
        let type = expressionTypesByCodingKey[typeKey]!
        self.expression = try type.init(from: container.superDecoder(forKey: .expression))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(type(of: expression).codingKey, forKey: .type)
        try expression.encode(to: container.superEncoder(forKey: .expression))
    }
}


var expressionTypes: [Expression.Type] = [] {
    didSet {
        expressionTypesByCodingKey = expressionTypes.reduce([:]) { result, type in
            var newResult = result
            newResult[type.codingKey] = type
            return newResult
        }
    }
}

var expressionTypesByCodingKey: [String:Expression.Type] = [:]
