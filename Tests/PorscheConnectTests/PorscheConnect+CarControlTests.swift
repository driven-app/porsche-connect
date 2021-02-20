import XCTest
@testable import PorscheConnect

final class PorscheConnectCarControlTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: Application = .CarControl
  let vehicle = Vehicle(vin: "A1234", modelDescription: "Taycan 4S", modelType: "Y1ADB1", modelYear: "2021", exteriorColorHex: "#47402e", attributes: nil, pictures: nil)
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
    self.connect.auths[application] = kTestPorschePortalAuth
  }
  
  // MARK: - Tests
  
  func testSummaryNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummaryFailure(router: BaseMockNetworkTestCase.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testVehiclesAuthRequiredAuthFailure() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: BaseMockNetworkTestCase.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: self.application))
      
      switch result {
      case .success:
        XCTFail("Should not have reached here")
      case .failure(let error):
        XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
}
