//
//  ScalarOperator.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

public struct ScalarAddition: BinaryOperator, ScalarValued {
    public var children: [Expression]
    
    public init(withChildren children: [Expression]) {
        self.children = children
    }
    
    public func evaluated(forVariableValuesByName valuesByName: [String:Value], parameters: EvaluationParameters) -> Value {
        let first = children[0].evaluated(forVariableValuesByName: valuesByName, parameters: parameters)
        let second = children[1].evaluated(forVariableValuesByName: valuesByName, parameters: parameters)
        return first + second
    }
    
    public var description: String {
        return "(\(children.first!) + \(children.last!))"
    }
}

public struct ScalarMultiplication: BinaryOperator, ScalarValued {
    public var children: [Expression]
    
    public init(withChildren children: [Expression]) {
        self.children = children
    }
    
    public func evaluated(forVariableValuesByName valuesByName: [String:Value], parameters: EvaluationParameters) -> Value {
        let first = children[0].evaluated(forVariableValuesByName: valuesByName, parameters: parameters)
        let second = children[1].evaluated(forVariableValuesByName: valuesByName, parameters: parameters)
        return first * second
    }
    
    public var description: String {
        return "(\(children.first!) * \(children.last!))"
    }
}
