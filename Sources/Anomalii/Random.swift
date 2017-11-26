//
//  Random.swift
//  Anomalii
//
//  Created by Drew McCormack on 14/11/2017.
//

import Foundation

extension Double {
    static var random: Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
}

extension ClosedRange where Bound == Int {
    var random: Int {
        return lowerBound + Int(arc4random() % UInt32(count))
    }
}

extension ClosedRange where Bound == Double {
    var random: Double {
        return lowerBound + Double.random * (upperBound-lowerBound)
    }
}

extension Array {
    var random: Element {
        return self[(0...count-1).random]
    }
    
    func random(choosing numberElements: Int) {
        
    }
}

