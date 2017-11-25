import XCTest
@testable import Anomalii

class ExpressionTests: XCTestCase {
    
    var expression: Expression!
    
    override func setUp() {
        super.setUp()
        expression = ScalarAddition(withChildren: [Constant(doubleValue: 10), Constant(doubleValue: 5)])
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
        let e = ScalarAddition(withChildren: [Variable(named: "tom"), Constant(doubleValue: 5)])
        guard case let .scalar(value) = e.evaluated(for: ["tom":.scalar(-2)]) else { XCTFail(); return }
        XCTAssertEqual(value, 3.0)
    }
    
    func testSameness() {
        let otherExpression = ScalarAddition(withChildren: [Constant(doubleValue: 5), Constant(doubleValue: 5)])
        XCTAssertTrue(Constant(doubleValue: 5.0).isSame(as: Constant(doubleValue: 5.0)))
        XCTAssertTrue(expression.isSame(as: expression))
        XCTAssertFalse(expression.isSame(as: otherExpression))
        XCTAssertFalse(Constant(doubleValue: -5.0).isSame(as: Constant(doubleValue: 5.0)))
        XCTAssertFalse(Variable(named: "blah").isSame(as: Constant(doubleValue: 5.0)))
        XCTAssertTrue(Variable(named: "blah").isSame(as: Variable(named: "blah")))
        XCTAssertFalse(Variable(named: "blah").isSame(as: Variable(named: "ball")))
        XCTAssertFalse(expression.isSame(as: Constant(doubleValue: 5.0)))
    }
    
    func testExtraction() {
        let firstChild = expression.expression(at: TraversalIndex(index: 0))
        let secondChild = expression.expression(at: TraversalIndex(index: 1))
        let root = expression.expression(at: TraversalIndex(index: 2))
        XCTAssertTrue(expression.isSame(as: root))
        XCTAssertTrue(Constant(doubleValue: 10).isSame(as: firstChild))
        XCTAssertTrue(Constant(doubleValue: 5).isSame(as: secondChild))
    }
    
    func testSubstitution() {
        let substituted = expression.expression(substituting: Variable(named: "bob"), at: TraversalIndex(index: 0))
        let result = ScalarAddition(withChildren: [Variable(named: "bob"), Constant(doubleValue: 5)])
        XCTAssertTrue(substituted.isSame(as: result))
    }
}
