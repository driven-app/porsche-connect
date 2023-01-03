import XCTest

@testable import PorscheConnect

final class PorscheConnectPortalTests: BaseMockNetworkTestCase {

  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .api

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
    connect.auths[application] = OAuthToken(authResponse: kTestPorschePortalAuth)
  }

  // MARK: - Tests

  func testVehiclesAuthRequiredSuccessful() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.vehicles()

    expectation.fulfill()
    XCTAssert(connect.authorized(application: application))
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.vehicles)
    XCTAssertEqual(1, result.vehicles!.count)
    assertVehicle(result.vehicles!.first!)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testVehiclesNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: router)

    XCTAssert(connect.authorized(application: application))

    let result = try! await connect.vehicles()

    expectation.fulfill()
    XCTAssert(connect.authorized(application: application))
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.vehicles)
    XCTAssertEqual(1, result.vehicles!.count)
    assertVehicle(result.vehicles!.first!)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testVehiclesNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesFailure(router: router)

    XCTAssert(connect.authorized(application: application))

    do {
      _ = try await connect.vehicles()
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testVehiclesAuthRequiredAuthFailure() async {
    connect.auths[application] = nil
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthFailure(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    do {
      _ = try await connect.vehicles()
    } catch {
      expectation.fulfill()
      XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Private functions

  private func assertVehicle(_ vehicle: Vehicle) {
    XCTAssertEqual("VIN12345", vehicle.vin)
    XCTAssertEqual("Porsche Taycan 4S", vehicle.modelDescription)
    XCTAssertEqual("A Test Model Type", vehicle.modelType)
    XCTAssertEqual("2021", vehicle.modelYear)
  }
}
