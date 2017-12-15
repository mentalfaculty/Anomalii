//
//  ScalarOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

public struct ScalarAddition: BinaryOperator, ScalarValued {
    public var children: [Expression]
    
    public init(withChildren children: [Expression]) {
        self.children = children
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first + second
    }
    
    public var description: String {
        return "(\(children.first!) + \(children.last!))"
    }
}

public struct ScalarMultiplication: BinaryOperator, ScalarValued {
    public var children: [Expression]
    
    public init(withChildren children: [Expression]) {
        self.children = children
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first * second
    }
    
    public var description: String {
        return "(\(children.first!) * \(children.last!))"
    }
}
