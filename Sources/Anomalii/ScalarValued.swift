//
//  Scalar.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

public protocol ScalarValued: Expression {
}

public extension ScalarValued {
    public static var outputType: Value.Kind { return .scalar }
}

extension ScalarValued where Self: BinaryOperator {
    static var inputTypes: [Value.Kind] { return [.scalar, .scalar] }
}
