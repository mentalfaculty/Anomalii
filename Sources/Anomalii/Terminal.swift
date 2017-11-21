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
    let doubleValue: Double
    static var outputType: Value.Kind { return .scalar }
    
    init(doubleValue: Double) {
        self.doubleValue = doubleValue
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value { return .scalar(doubleValue) }
}

struct Variable: Terminal {
    
    let name: String
    static let outputType: Value.Kind = .scalar
    
    init(name: String) {
        self.name = name
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        return valuesByString[name]!
    }
}

