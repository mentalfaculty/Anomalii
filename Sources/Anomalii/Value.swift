//
//  Value.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

public enum Value {
    case scalar(Double)
    case vector([Double])
    
    public enum Kind {
        case scalar
        case vector
    }
    
    public var kind: Value.Kind {
        switch self {
        case .scalar:
            return .scalar
        case .vector:
            return .vector
        }
    }
    
    static func +(left: Value, right: Value) -> Value {
        switch (left, right) {
        case let (.scalar(l), .scalar(r)):
            return .scalar(l+r)
        case let (.vector(l), .vector(r)):
            return .vector(zip(l, r).map({ (l,r) in l+r }))
        case (.scalar, .vector), (.vector, .scalar):
            fatalError()
        }
    }
    
    static func *(left: Value, right: Value) -> Value {
        switch (left, right) {
        case let (.scalar(l), .scalar(r)):
            return .scalar(l*r)
        case let (.vector(l), .vector(r)):
            return .vector(zip(l, r).map({ (l,r) in l*r }))
        case let (.scalar(s), .vector(v)):
            return .vector(v.map({ $0 * s }))
        case let (.vector(v), .scalar(s)):
            return .vector(v.map({ $0 * s }))
        }
    }
    
    static func dotProduct(_ left: Value, _ right: Value) -> Value {
        switch (left, right) {
        case let (.vector(l), .vector(r)):
            return .scalar(zip(l, r).reduce(0.0, { (sum, pair) in sum + pair.0*pair.1 }))
        case (.scalar, .scalar), (.scalar, .vector), (.vector, .scalar):
            fatalError()
        }
    }
}
