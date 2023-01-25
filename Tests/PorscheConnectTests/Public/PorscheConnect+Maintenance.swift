import XCTest
import func XCTAsync.XCTAssertFalse
import func XCTAsync.XCTAssertTrue

@testable import PorscheConnect

final class PorscheConnectMaintenanceTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .api
  let vin = "A1234"
  
  // MARK: - Lifecycle
  
  override func setUp() async throws {
    try await super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
    try await connect.authStorage.storeAuthentication(
      token: OAuthToken(authResponse: kTestPorschePortalAuth),
      for: application.clientId
    )
  }
  
  // MARK: - Tests
  
  func testMaintenanceNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetMaintenanceSuccessful(router: router)
    
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    let results = try! await connect.maintenance(vin: vin)

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(results)
    XCTAssertNotNil(results.maintenance)
    XCTAssertNotNil(results.maintenance!.items)
    XCTAssertEqual(2, results.maintenance!.items.count)

    // Maintenance Item One
    
    let maintenanceItemOne = results.maintenance!.items.first!
    XCTAssertEqual("0003", maintenanceItemOne.id)
    
    XCTAssertEqual("Service", maintenanceItemOne.description.shortName)
    XCTAssertEqual("No service is due at the moment.", maintenanceItemOne.description.criticalityText)
    XCTAssertNil(maintenanceItemOne.description.longName)
    XCTAssertNil(maintenanceItemOne.description.notificationText)
    
    XCTAssertEqual(1, maintenanceItemOne.criticality)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimeInDays)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimePercentage)
    XCTAssertNil(maintenanceItemOne.remainingLifeTimeInKm)
    
    XCTAssertEqual("Service-Intervall", maintenanceItemOne.values.modelName)
    XCTAssertEqual("0", maintenanceItemOne.values.odometerLastReset)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.VisibilityState.visible, maintenanceItemOne.values.modelVisibilityState)
    XCTAssertEqual("1", maintenanceItemOne.values.criticality)
    XCTAssertEqual("0003", maintenanceItemOne.values.modelId)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.ModelState.active, maintenanceItemOne.values.modelState)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Source.vehicle, maintenanceItemOne.values.source)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Event.cyclic, maintenanceItemOne.values.event)
    
    // Maintenance Item Two
    
    let maintenanceItemTwo = results.maintenance!.items.last!
    XCTAssertEqual("0005", maintenanceItemTwo.id)

    XCTAssertEqual("Brake pads", maintenanceItemTwo.description.shortName)
    XCTAssertEqual("No service is due at the moment.", maintenanceItemTwo.description.criticalityText)
    XCTAssertEqual("Changing the brake pads", maintenanceItemTwo.description.longName)
    XCTAssertNil(maintenanceItemTwo.description.notificationText)
    
    XCTAssertEqual(1, maintenanceItemTwo.criticality)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimeInDays)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimePercentage)
    XCTAssertNil(maintenanceItemTwo.remainingLifeTimeInKm)
    
    XCTAssertEqual("Service Bremse", maintenanceItemTwo.values.modelName)
    XCTAssertEqual("0", maintenanceItemTwo.values.odometerLastReset)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.VisibilityState.visible, maintenanceItemTwo.values.modelVisibilityState)
    XCTAssertEqual("1", maintenanceItemTwo.values.criticality)
    XCTAssertEqual("0005", maintenanceItemTwo.values.modelId)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.ModelState.active, maintenanceItemTwo.values.modelState)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Source.vehicle, maintenanceItemTwo.values.source)
    XCTAssertEqual(Maintenance.MaintenanceItemValues.Event.cyclic, maintenanceItemTwo.values.event)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testMaintenanceNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetMaintenanceFailure(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    do {
      _ = try await connect.maintenance(vin: vin)
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}

