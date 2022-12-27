import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
  }
  
  // MARK: - Tests
  
  func testConstruction() {
    XCTAssertNotNil(connect)
    XCTAssertEqual(Environment.Test, connect.environment)
    XCTAssertEqual("homer.simpson@icloud.example", connect.username)
    XCTAssertNotNil(connect.auths)
    XCTAssertFalse(connect.authorized(application: .Api))
    XCTAssertFalse(connect.authorized(application: .CarControl))
  }
  
  func testEnvironmentIreland() {
    let environment = Environment.Ireland
    XCTAssertNotNil(environment)
    XCTAssertEqual("ie/en_GB", environment.regionCode)
    XCTAssertEqual("en", environment.languageCode)
    XCTAssertEqual("ie", environment.countryCode)
  }
  
  func testEnvironmentGermany() {
    let environment = Environment.Germany
    XCTAssertNotNil(environment)
    XCTAssertEqual("de/de_DE", environment.regionCode)
    XCTAssertEqual("de", environment.languageCode)
    XCTAssertEqual("de", environment.countryCode)
  }
  
  func testEnvironmentTest() {
    let environment = Environment.Test
    XCTAssertNotNil(environment)
    XCTAssertEqual("ie/en_IE", environment.regionCode)
    XCTAssertEqual("en", environment.languageCode)
    XCTAssertEqual("ie", environment.countryCode)
  }
  
  func testApplicationClientIdPortal() {
    let application = Application.Api
    XCTAssertEqual("4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA", application.clientId)
  }
  
  func testApplicationClientIdCarControl() {
    let application = Application.CarControl
    XCTAssertEqual("Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs", application.clientId)
  }
  
  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
}
