import XCTest

@testable import PorscheConnect

final class PorscheConnectTests: BaseMockNetworkTestCase {

  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
  }

  // MARK: - Tests

  func testConstruction() {
    XCTAssertNotNil(connect)
    XCTAssertEqual(Environment.test, connect.environment)
    XCTAssertEqual("homer.simpson@icloud.example", connect.username)
    XCTAssertNotNil(connect.auths)
    XCTAssertFalse(connect.authorized(application: .api))
    XCTAssertFalse(connect.authorized(application: .carControl))
  }

  func testEnvironmentProduction() {
    let environment = Environment.production
    XCTAssertNotNil(environment)
    XCTAssertEqual("de/de_DE", environment.regionCode)
    XCTAssertEqual("de", environment.languageCode)
    XCTAssertEqual("de", environment.countryCode)
  }

  func testEnvironmentTest() {
    let environment = Environment.test
    XCTAssertNotNil(environment)
    XCTAssertEqual("ie/en_IE", environment.regionCode)
    XCTAssertEqual("en", environment.languageCode)
    XCTAssertEqual("ie", environment.countryCode)
  }

  func testApplicationClientIdPortal() {
    let application = Application.api
    XCTAssertEqual("4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA", application.clientId)
  }

  func testApplicationClientIdCarControl() {
    let application = Application.carControl
    XCTAssertEqual("Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs", application.clientId)
  }

  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
}
