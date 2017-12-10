//
//  Constant.swift
//  Anomalii
//
//  Created by Drew McCormack on 10/12/2017.
//

import Foundation

public protocol Constant: Terminal {
}

public struct ScalarConstant: Constant, ScalarValued {
    let doubleValue: Double
    
    init(doubleValue: Double) {
        self.doubleValue = doubleValue
    }
    
    enum Key: String, CodingKey {
        case doubleValue
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        doubleValue = try values.decode(Double.self, forKey: .doubleValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(doubleValue, forKey: .doubleValue)
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value { return .scalar(doubleValue) }
    
    public func isSame(as other: Expression) -> Bool {
        guard let otherConstant = other as? ScalarConstant else { return false }
        return doubleValue == otherConstant.doubleValue
    }
    
    public var description: String {
        return "\(doubleValue)"
    }
}

public struct VectorConstant: Constant, VectorValued {
    let vectorValue: [Double]

    init(vectorValue: [Double]) {
        self.vectorValue = vectorValue
    }
    
    enum Key: String, CodingKey {
        case vectorValue
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        vectorValue = try values.decode([Double].self, forKey: .vectorValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(vectorValue, forKey: .vectorValue)
    }
    
    public func evaluated(for valuesByString: [String:Value]) -> Value { return .vector(vectorValue) }
    
    public func isSame(as other: Expression) -> Bool {
        guard let otherConstant = other as? VectorConstant else { return false }
        return vectorValue == otherConstant.vectorValue
    }
    
    public var description: String {
        return "\(vectorValue)"
    }
}
