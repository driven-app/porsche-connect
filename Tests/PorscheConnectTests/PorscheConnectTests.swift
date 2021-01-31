import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: XCTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(environment: .Test, username: "homer.simpson@icloud.example", password: "Duh!")
  }
  
  func testConstruction() {
    XCTAssertNotNil(self.connect)
    XCTAssertEqual(Environment.Test, self.connect.environment)
    XCTAssertEqual("homer.simpson@icloud.example", self.connect.username)
  }
      

}
