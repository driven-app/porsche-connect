import XCTest
@testable import PorscheConnect

final class PorscheConnectPortalTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(environment: .Test, username: "homer.simpson@icloud.example", password: "Duh!")
    self.connect.auth = kMockPorscheAuth
  }
  
  // MARK: - Tests
  
  func testVehiclesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssert(self.connect.authorized)
    
    self.connect.vehicles(success: { (vehicles, response, responseJson) in
      expectation.fulfill()
      XCTAssert(self.connect.authorized)
      
    })
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}
