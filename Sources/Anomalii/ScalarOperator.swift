//
//  ScalarOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

struct ScalarAddition: BinaryOperator, ScalarValued {
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first + second
    }
    
    var description: String {
        return "(\(children.first!) + \(children.last!))"
    }
}

struct ScalarMultiplication: BinaryOperator, ScalarValued {
    var children: [Expression]
    
    init(withChildren children: [Expression]) {
        self.children = children
    }
    
    func evaluated(for valuesByString: [String:Value]) -> Value {
        let first = children[0].evaluated(for: valuesByString)
        let second = children[1].evaluated(for: valuesByString)
        return first * second
    }
    
    var description: String {
        return "(\(children.first!) * \(children.last!))"
    }
}
