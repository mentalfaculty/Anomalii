//
//  CodableTests.swift
//  AnomaliiTests
//
//  Created by Drew McCormack on 24/11/2017.
//

import XCTest
@testable import Anomalii

class CodableTests: XCTestCase {
    
    var expression: ScalarAddition!
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()

    override func setUp() {
        super.setUp()
        expressionTypes = [ScalarAddition.self, ScalarMultiplication.self, ScalarConstant.self, ScalarVariable.self]
        expression = ScalarAddition(withChildren: [ScalarConstant(doubleValue: 10), ScalarConstant(doubleValue: 5)])
    }
    
    func testEncodeAndDecode() {
        let data = try! jsonEncoder.encode(expression)
        let newExpression = try! jsonDecoder.decode(ScalarAddition.self, from: data)
        XCTAssert(expression.isSame(as: newExpression))
    }
    
    func testAnyExpressionEncodeAndDecode() {
        let data = try! jsonEncoder.encode(AnyExpression(expression))
        let any = try! jsonDecoder.decode(AnyExpression.self, from: data)
        XCTAssert(expression.isSame(as: any.expression))
    }
}
