import XCTest
@testable import PorscheConnect

final class PorscheConnectPortalTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
    self.connect.auth = kTestPorscheAuth
  }
  
  // MARK: - Tests
  
  func testVehiclesAuthRequiredSuccessful() {
    self.connect.auth = nil
    let expectation = self.expectation(description: "Network Expectation")
    
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: BaseMockNetworkTestCase.router)
    
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized)
    XCTAssertNil(self.connect.auth)
    
    self.connect.vehicles { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized)
      XCTAssertNotNil(result)

      let vehicles = try! result.get()!
      XCTAssertEqual(1, vehicles.count)
      self.assertVehicle(vehicles.first!)
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testVehiclesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssert(self.connect.authorized)
    
    self.connect.vehicles { result in
      expectation.fulfill()
      XCTAssert(self.connect.authorized)
      XCTAssertNotNil(result)
      
      let vehicles = try! result.get()!
      XCTAssertEqual(1, vehicles.count)
      self.assertVehicle(vehicles.first!)
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
