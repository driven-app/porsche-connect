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
    self.connect.auth = kTestPorscheAuth
  }
  
  // MARK: - Tests
  
  func testVehiclesNoAuthRequiredSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssert(self.connect.authorized)
    
    self.connect.vehicles(success: { (body, response, responseJson) in
      expectation.fulfill()
      XCTAssert(self.connect.authorized)
      XCTAssertNotNil(body)
      XCTAssertNotNil(response)
      XCTAssertNotNil(responseJson)
      
      let vehicles = body as! [Vehicle]
      XCTAssertEqual(1, vehicles.count)
      self.assertVehicle(vehicles.first!)
    })
    
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
