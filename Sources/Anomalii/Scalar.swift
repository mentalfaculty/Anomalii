//
//  Scalar.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Scalar: Expression {
}

extension Scalar {
    static var outputType: ValueType { return .scalar }
}

extension Scalar where Self: BinaryOperator {
    static var inputTypes: [ValueType] { return [.scalar, .scalar] }
}
