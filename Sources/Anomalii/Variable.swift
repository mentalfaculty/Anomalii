//
//  Variable.swift
//  Anomalii
//
//  Created by Drew McCormack on 10/12/2017.
//

import Foundation

public protocol Variable: Terminal {
    var name: String { get }
}

public struct ScalarVariable: Variable, ScalarValued {
    public let name: String
    public static let outputValueKind: Value.Kind = .scalar
    
    public init(named name: String) {
        self.name = name
    }
    
    private enum Key: String, CodingKey {
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(name, forKey: .name)
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value {
        return valuesByString[name]!
    }
    
    public func isSame(as other: Expression) -> Bool {
        guard let otherVariable = other as? Variable else { return false }
        return name == otherVariable.name
    }
    
    public var description: String {
        return "\(name)"
    }
}

public struct VectorVariable: Variable, VectorValued {
    public let name: String
    public static let outputValueKind: Value.Kind = .vector
    
    public init(named name: String) {
        self.name = name
    }
    
    private enum Key: String, CodingKey {
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(name, forKey: .name)
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value {
        return valuesByString[name]!
    }
    
    public func isSame(as other: Expression) -> Bool {
        guard let otherVariable = other as? Variable else { return false }
        return name == otherVariable.name
    }
    
    public var description: String {
        return "\(name)"
    }
}

