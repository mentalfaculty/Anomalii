import XCTest
@testable import Anomalii

class ExpressionTests: XCTestCase {
    
    var expression: Expression!
    
    override func setUp() {
        super.setUp()
        expression = ScalarAddition(withChildren: [Constant(value: 10), Constant(value: 5)])
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCount() {
        XCTAssertEqual(expression.count(where: nil), 3)
    }
    
    func testCountWithCondition() {
        XCTAssertEqual(expression.count(where: { $0 is Terminal }), 2)
    }
    
    func testDepth() {
        XCTAssertEqual(expression.depth, 2)
    }
    
    func testEvaluation() {
        XCTAssertEqual(expression.evaluated(for: [:]) as! Double, 15.0)
    }
}
