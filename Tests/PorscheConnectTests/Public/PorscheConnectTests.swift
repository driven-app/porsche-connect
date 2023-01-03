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

  func testEnvironmentGermany() {
    let environment = Environment.germany
    XCTAssertNotNil(environment)
    XCTAssertEqual(environment.regionCode, "de/de_DE")
    XCTAssertEqual(environment.languageCode, LanguageCode.german.rawValue)
    XCTAssertEqual(environment.countryCode, CountryCode.germany.rawValue)
  }

  func testEnvironmentCustom() {
    let environment = Environment(
      countryCode: CountryCode.unitedStates.rawValue,
      languageCode: LanguageCode.english.rawValue,
      regionCode: "us/en_US"
    )
    XCTAssertNotNil(environment)
    XCTAssertEqual(environment.regionCode, "us/en_US")
    XCTAssertEqual(environment.languageCode, LanguageCode.english.rawValue)
    XCTAssertEqual(environment.countryCode, CountryCode.unitedStates.rawValue)
  }

  func testEnvironmentTest() {
    let environment = Environment.test
    XCTAssertNotNil(environment)
    XCTAssertEqual(environment.regionCode, "ie/en_IE")
    XCTAssertEqual(environment.languageCode, LanguageCode.english.rawValue)
    XCTAssertEqual(environment.countryCode, CountryCode.ireland.rawValue)
  }

  func testApplicationClientIdPortal() {
    let application = OAuthApplication.api
    XCTAssertEqual(application.clientId, "4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA")
  }

  func testApplicationClientIdCarControl() {
    let application = OAuthApplication.carControl
    XCTAssertEqual(application.clientId, "Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs")
  }

  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
}
