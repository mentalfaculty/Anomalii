//
//  Value.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

enum ValueType {
    case scalar
}

protocol Value {
    static var type: ValueType { get }
}

extension Double: Value {
    static var type: ValueType { return .scalar }
}
