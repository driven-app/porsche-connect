import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PorscheConnect().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
