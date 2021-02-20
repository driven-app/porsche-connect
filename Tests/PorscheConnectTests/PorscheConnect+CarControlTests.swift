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
  
  func testSummaryAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: BaseMockNetworkTestCase.router)
    
    mockNetworkRoutes.mockGetSummarySuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (summary, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(summary)
        self.assertSumary(summary!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testVehiclesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetSummarySuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.summary(vehicle: vehicle) { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (summary, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(summary)
        self.assertSumary(summary!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
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
  
  // MARK: - Private functions
  
  private func assertSumary(_ summary: Summary) {
    XCTAssertEqual("Taycan 4S", summary.modelDescription)
    XCTAssertEqual("211-D-12345", summary.nickName)
  }
}
