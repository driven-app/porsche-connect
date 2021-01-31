import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
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
  
  func testNetworkRoutesIreland() {
    let networkRoute = NetworkRoutes(environment: .Ireland)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/ie/en_GB/public/login")!, networkRoute.loginAuthURL())
  }
  
  func testNetworkRoutesGermany() {
    let networkRoute = NetworkRoutes(environment: .Germany)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/de/de_DE/public/login")!, networkRoute.loginAuthURL())
  }
  
  func testNetworkRoutesTest() {
    let networkRoute = NetworkRoutes(environment: .Test)
    XCTAssertEqual(URL(string: "https://localhost:\(kTestServerPort)/auth/api/v1/ie/en_IE/public/login")!, networkRoute.loginAuthURL())
  }
  
//  func testSuccessfulAuth() {
//    let expectation = self.expectation(description: "Network Expectation")
//    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
//
//    self.connect.auth { (body, response, responseJson) in
//      expectation.fulfill()
//    }
//
//    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
//  }
}
