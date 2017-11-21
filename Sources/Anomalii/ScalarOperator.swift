//
//  ScalarOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

struct ScalarAddition: BinaryOperator, Scalar {
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first + second
    }
}

struct ScalarMultiply: BinaryOperator, Scalar {
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first * second
    }
}
