//
//  Vector.swift
//  Anomalii
//
//  Created by Drew McCormack on 10/12/2017.
//

import Foundation

public protocol VectorValued: Expression {
}

extension VectorValued {
    public static var outputValueKind: Value.Kind { return .vector }
}

extension VectorValued where Self: BinaryOperator {
    static var inputValueKinds: [Value.Kind] { return [.vector, .vector] }
}
