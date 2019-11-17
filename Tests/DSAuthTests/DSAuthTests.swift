import XCTest
@testable import DSAuth

final class DSAuthTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DSAuth().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
