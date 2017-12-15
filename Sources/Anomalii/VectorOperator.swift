//
//  VectorOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 05/12/2017.
//

import Foundation

public struct VectorAddition: BinaryOperator {
    public static var inputValueKinds: [Value.Kind] { return [.vector, .vector] }
    public static var outputValueKind: Value.Kind { return .vector }
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

public struct ScalarVectorMultiplication: BinaryOperator {
    public static var inputValueKinds: [Value.Kind] { return [.scalar, .vector] }
    public static var outputValueKind: Value.Kind { return .vector }
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

public struct DotProduct: BinaryOperator {
    public static var inputValueKinds: [Value.Kind] { return [.vector, .vector] }
    public static var outputValueKind: Value.Kind { return .scalar }
    public var children: [Expression]
    
    public init(withChildren children: [Expression]) {
        self.children = children
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return Value.dotProduct(first, second)
    }
    
    public var description: String {
        return "(\(children.first!) . \(children.last!))"
    }
}
