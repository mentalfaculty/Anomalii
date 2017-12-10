import XCTest
@testable import Anomalii

class ExpressionTests: XCTestCase {
    
    var expression: Expression!
    
    override func setUp() {
        super.setUp()
        expression = ScalarAddition(withChildren: [ScalarConstant(doubleValue: 10), ScalarConstant(doubleValue: 5)])
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
        guard case let .scalar(value) = expression.evaluated(for: [:]) else { XCTFail(); return }
        XCTAssertEqual(value, 15.0)
    }
    
    func testEvaluationWithVariable() {
        let e = ScalarAddition(withChildren: [ScalarVariable(named: "tom"), ScalarConstant(doubleValue: 5)])
        guard case let .scalar(value) = e.evaluated(for: ["tom":.scalar(-2)]) else { XCTFail(); return }
        XCTAssertEqual(value, 3.0)
    }
    
    func testSameness() {
        let otherExpression = ScalarAddition(withChildren: [ScalarConstant(doubleValue: 5), ScalarConstant(doubleValue: 5)])
        XCTAssertTrue(ScalarConstant(doubleValue: 5.0).isSame(as: ScalarConstant(doubleValue: 5.0)))
        XCTAssertTrue(expression.isSame(as: expression))
        XCTAssertFalse(expression.isSame(as: otherExpression))
        XCTAssertFalse(ScalarConstant(doubleValue: -5.0).isSame(as: ScalarConstant(doubleValue: 5.0)))
        XCTAssertFalse(ScalarVariable(named: "blah").isSame(as: ScalarConstant(doubleValue: 5.0)))
        XCTAssertTrue(ScalarVariable(named: "blah").isSame(as: ScalarVariable(named: "blah")))
        XCTAssertFalse(ScalarVariable(named: "blah").isSame(as: ScalarVariable(named: "ball")))
        XCTAssertFalse(expression.isSame(as: ScalarConstant(doubleValue: 5.0)))
    }
    
    func testExtraction() {
        let firstChild = expression.expression(at: TraversalIndex(index: 0))
        let secondChild = expression.expression(at: TraversalIndex(index: 1))
        let root = expression.expression(at: TraversalIndex(index: 2))
        XCTAssertTrue(expression.isSame(as: root))
        XCTAssertTrue(ScalarConstant(doubleValue: 10).isSame(as: firstChild))
        XCTAssertTrue(ScalarConstant(doubleValue: 5).isSame(as: secondChild))
    }
    
    func testSubstitution() {
        let substituted = expression.expression(substituting: ScalarVariable(named: "bob"), at: TraversalIndex(index: 0))
        let result = ScalarAddition(withChildren: [ScalarVariable(named: "bob"), ScalarConstant(doubleValue: 5)])
        XCTAssertTrue(substituted.isSame(as: result))
    }
}
