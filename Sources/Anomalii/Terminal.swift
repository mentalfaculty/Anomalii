//
//  Terminal.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation


public protocol Terminal: Expression {
}

public extension Terminal {
    public static var arity: Int { return 0 }
    public var isValid: Bool { return true }
    public var depth: Int { return 1 }
    
    public func traverse(executingForEach visiter: (Expression)->Void) {
        visiter(self)
    }
    
    public func traverse(where condition: ((Expression)->Bool)? = nil, visitWith visiter: (Expression) -> Void) {
        if (condition?(self) ?? true) { visiter(self) }
    }
    
    public func transformed(where condition: ((Expression)->Bool)? = nil, by transformer: (Expression)->Expression) -> Expression {
        return (condition?(self) ?? true) ? transformer(self) : self
    }
    
    public func count(where condition: ((Expression) -> Bool)?) -> Int {
        return condition?(self) ?? false ? 1 : 0
    }
}


