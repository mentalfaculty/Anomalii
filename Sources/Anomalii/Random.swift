//
//  Random.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

public extension Double {
    public static var random: Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
}

public extension ClosedRange where Bound == Int {
    public var random: Int {
        return lowerBound + Int(arc4random() % UInt32(count))
    }
}

public extension ClosedRange where Bound == Double {
    public var random: Double {
        return lowerBound + Double.random * (upperBound-lowerBound)
    }
}

public extension Array {
    public var random: Element {
        return self[(0...count-1).random]
    }
    
    public func random(choosing numberElements: Int) -> [Element] {
        guard numberElements < count else { return self }
        var indexes = Set<Int>()
        while indexes.count < numberElements {
            let random: Int = (0...count-1).random
            indexes.insert(random)
        }
        return indexes.map { self[$0] }
    }
}

