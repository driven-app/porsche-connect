import XCTest
@testable import PorscheConnect

final class NetworkRoutesTests: XCTestCase {
  
  var capabilities: Capabilities?
  
  override func setUp() {
    super.setUp()
    capabilities = buildCapabilites()
  }
  
  func testApplicationRedirectURLPortal() {
    let application = Application.api
    XCTAssertEqual(URL(string: "https://my.porsche.com/core/de/de_DE")!, application.redirectURL)
  }
  
  func testApplicationClientIdCarControl() {
    let application = Application.carControl
    XCTAssertEqual("Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs", application.clientId)
  }
  
  func testApplicationRedirectURLCarControl() {
    let application = Application.carControl
    XCTAssertEqual(URL(string: "https://my.porsche.com/myservices/auth/auth.html")!, application.redirectURL)
  }
  
  func testNetworkRoutesProduction() {
    let networkRoute = NetworkRoutes(environment: .production)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/de/de_DE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)
    
    let vehicle = Vehicle(vin: "12345X")
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/vehicle-summary/12345X"), networkRoute.vehicleSummaryURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/car-finder/12345X/position"), networkRoute.vehiclePositionURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/vcs/capabilities/12345X"), networkRoute.vehicleCapabilitiesURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "https://api.porsche.com/service-vehicle/de/de_DE/e-mobility/J1/12345X?timezone=Europe/Dublin"), networkRoute.vehicleEmobilityURL(vehicle: vehicle, capabilities: capabilities!))
  }
  
  func testNetworkRoutesTest() {
    let networkRoute = NetworkRoutes(environment: .test)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/ie/en_IE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!, networkRoute.apiTokenURL)
    
    let vehicle = Vehicle(vin: "12345X")
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vehicle-summary/12345X"), networkRoute.vehicleSummaryURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/car-finder/12345X/position"), networkRoute.vehiclePositionURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/vcs/capabilities/12345X"), networkRoute.vehicleCapabilitiesURL(vehicle: vehicle))
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/service-vehicle/ie/en_IE/e-mobility/J1/12345X?timezone=Europe/Dublin"), networkRoute.vehicleEmobilityURL(vehicle: vehicle, capabilities: capabilities!))
  }
}
