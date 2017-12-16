//
//  General.swift
//  Anomalii
//
//  Created by Drew McCormack on 16/12/2017.
//

import Foundation

func repeatedlyAttemptToCreate<T>(maximumAttempts: Int = 10, makingWith creationBlock: ()->T?) -> T? {
    var attempts = 0
    var result: T?
    while result == nil && attempts < maximumAttempts {
        attempts += 1
        result = creationBlock()
    }
    return result
}
