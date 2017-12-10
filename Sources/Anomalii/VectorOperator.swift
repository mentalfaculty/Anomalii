//
//  VectorOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 05/12/2017.
//

import Foundation

struct VectorAddition: BinaryOperator {
    static var inputTypes: [Value.Kind] { return [.vector, .vector] }
    static var outputType: Value.Kind { return .vector }
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first + second
    }
    
    var description: String {
        return "(\(children.first!) + \(children.last!))"
    }
}

struct DotProduct: BinaryOperator {
    static var inputTypes: [Value.Kind] { return [.vector, .vector] }
    static var outputType: Value.Kind { return .scalar }
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return Value.dotProduct(first, second)
    }
    
    var description: String {
        return "(\(children.first!) . \(children.last!))"
    }
}
