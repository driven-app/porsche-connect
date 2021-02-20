import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
  }
  
  // MARK: - Tests
  
  func testConstruction() {
    XCTAssertNotNil(self.connect)
    XCTAssertEqual(Environment.Test, self.connect.environment)
    XCTAssertEqual("homer.simpson@icloud.example", self.connect.username)
    XCTAssertNotNil(self.connect.auths)
    XCTAssertFalse(self.connect.authorized(application: .Portal))
    XCTAssertFalse(self.connect.authorized(application: .CarControl))
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
    let application = Application.Portal
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", application.clientId)
  }
  
  func testApplicationClientIdCarControl() {
    let application = Application.CarControl
    XCTAssertEqual("gZLSI7ThXFB4d2ld9t8Cx2DBRvGr1zN2", application.clientId)
  }
  
  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
}
