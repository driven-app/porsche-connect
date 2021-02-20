import XCTest
@testable import PorscheConnect

final class PorscheConnectPortalTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: Application = .Portal
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
    self.connect.auths[application] = kTestPorschePortalAuth
  }
  
  // MARK: - Tests
  
  func testVehiclesAuthRequiredSuccessful() {
    connect.auths[application] = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    
    connect.vehicles { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (vehicles, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(vehicles)
        XCTAssertEqual(1, vehicles!.count)
        self.assertVehicle(vehicles!.first!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testVehiclesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))

    connect.vehicles { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized(application: self.application))
      
      switch result {
      case .success(let (vehicles, response)):
        XCTAssertNotNil(response)
        XCTAssertNotNil(vehicles)
        XCTAssertEqual(1, vehicles!.count)
        self.assertVehicle(vehicles!.first!)
      case .failure:
        XCTFail("Should not have reached here")
      }
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testVehiclesNoAuthRequiredFailure() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesFailure(router: MockServer.shared.router)
    
    XCTAssert(connect.authorized(application: application))
    
    connect.vehicles { result in
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
    
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)

    XCTAssertFalse(connect.authorized(application: application))
    
    self.connect.vehicles { result in
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
  
  private func assertVehicle(_ vehicle: Vehicle) {
    XCTAssertEqual("VIN12345", vehicle.vin)
    XCTAssertEqual("Porsche Taycan 4S", vehicle.modelDescription)
    XCTAssertEqual("A Test Model Type", vehicle.modelType)
    XCTAssertEqual("2021", vehicle.modelYear)
  }
}
