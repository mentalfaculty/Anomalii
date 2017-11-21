//
//  Scalar.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

protocol Scalar: Expression {
}

extension Scalar {
    static var outputType: Value.Kind { return .scalar }
}

extension Scalar where Self: BinaryOperator {
    static var inputTypes: [Value.Kind] { return [.scalar, .scalar] }
}
