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
    XCTAssertFalse(self.connect.authorized)
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
    XCTAssertNotNil(application)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", application.clientId)
  }
  
  func testApplicationRedirectURLPortal() {
    let application = Application.Portal
    XCTAssertNotNil(application)
    XCTAssertEqual(URL(string: "https://my-static02.porsche.com/static/cms/auth.html")!, application.redirectURL)
  }
  
  func testNetworkRoutesIreland() {
    let networkRoute = NetworkRoutes(environment: .Ireland)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/ie/en_GB/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)
    
    let vehicle = Vehicle(vin: "12345X", modelDescription: "Taycan 4S", modelType: "ABC123", modelYear: "2021", exteriorColorHex: "#478be7", attributes: nil, pictures: nil)
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/12345X"), networkRoute.vehicleSummaryURL(vehicle: vehicle))
  }
  
  func testNetworkRoutesGermany() {
    let networkRoute = NetworkRoutes(environment: .Germany)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/de/de_DE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)
    
    let vehicle = Vehicle(vin: "12345X", modelDescription: "Taycan 4S", modelType: "ABC123", modelYear: "2021", exteriorColorHex: "#478be7", attributes: nil, pictures: nil)
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/12345X"), networkRoute.vehicleSummaryURL(vehicle: vehicle))
  }
  
  func testNetworkRoutesTest() {
    let networkRoute = NetworkRoutes(environment: .Test)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/ie/en_IE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!, networkRoute.apiTokenURL)
    
    let vehicle = Vehicle(vin: "12345X", modelDescription: "Taycan 4S", modelType: "ABC123", modelYear: "2021", exteriorColorHex: "#478be7", attributes: nil, pictures: nil)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/12345X"), networkRoute.vehicleSummaryURL(vehicle: vehicle))
  }
  
  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
}
