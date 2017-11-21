//
//  Value.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

enum Value {
    case scalar(Double)
    
    enum Kind {
        case scalar
    }
    
    var kind: Value.Kind {
        switch self {
        case .scalar:
            return .scalar
        }
    }
    
    static func +(left: Value, right: Value) -> Value {
        switch (left, right) {
        case let (.scalar(l), .scalar(r)):
            return .scalar(l+r)
        }
    }
    
    static func *(left: Value, right: Value) -> Value {
        switch (left, right) {
        case let (.scalar(l), .scalar(r)):
            return .scalar(l*r)
        }
    }
}
