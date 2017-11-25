//
//  Terminal.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation


protocol Terminal: Expression {
}

extension Terminal {
    static var arity: Int { return 0 }
    var isValid: Bool { return true }
    var depth: Int { return 1 }
    
    func traverse(executingForEach visiter: (Expression)->Void) {
        visiter(self)
    }
    
    func traverse(where condition: ((Expression)->Bool)? = nil, visitWith visiter: (Expression) -> Void) {
        if (condition?(self) ?? true) { visiter(self) }
    }
    
    func transformed(where condition: ((Expression)->Bool)? = nil, by transformer: (Expression)->Expression) -> Expression {
        return (condition?(self) ?? true) ? transformer(self) : self
    }
    
    func count(where condition: ((Expression) -> Bool)?) -> Int {
        return condition?(self) ?? false ? 1 : 0
    }
}

struct Constant: Terminal {
    static let codingKey = "constant"
    let doubleValue: Double
    static var outputType: Value.Kind { return .scalar }
    
    init(doubleValue: Double) {
        self.doubleValue = doubleValue
    }
    
    enum Key: String, CodingKey {
        case doubleValue
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        doubleValue = try values.decode(Double.self, forKey: .doubleValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(doubleValue, forKey: .doubleValue)
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value { return .scalar(doubleValue) }
    
    func isSame(as other: Expression) -> Bool {
        guard let otherConstant = other as? Constant else { return false }
        return doubleValue == otherConstant.doubleValue
    }
}

struct Variable: Terminal {
    static let codingKey = "variable"
    let name: String
    static let outputType: Value.Kind = .scalar
    
    init(name: String) {
        self.name = name
    }
    
    enum Key: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(name, forKey: .name)
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        return valuesByString[name]!
    }
    
    func isSame(as other: Expression) -> Bool {
        guard let otherVariable = other as? Variable else { return false }
        return name == otherVariable.name
    }
}

