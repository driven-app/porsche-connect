import XCTest
import func XCTAsync.XCTAssertFalse
import func XCTAsync.XCTAssertTrue

@testable import PorscheConnect

final class PorscheConnectPortalTests: BaseMockNetworkTestCase {

  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .api

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

  func testVehiclesAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockGetAuth0InitialStateSuccessful(router: router)
    mockNetworkRoutes.mockPostLoginDetailsAuth0Successful(router: router)
    mockNetworkRoutes.mockGetAuth0CallbackSuccessful(router: router)
    mockNetworkRoutes.mockGetAuth0ResumeAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostAuth0AccessTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.vehicles()

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.vehicles)
    XCTAssertEqual(1, result.vehicles!.count)
    assertVehicle(result.vehicles!.first!)

    await fulfillment(of: [expectation], timeout: kDefaultTestTimeout)
  }

  func testVehiclesNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesSuccessful(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    let result = try! await connect.vehicles()

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.vehicles)
    XCTAssertEqual(1, result.vehicles!.count)
    assertVehicle(result.vehicles!.first!)

    await fulfillment(of: [expectation], timeout: kDefaultTestTimeout)
  }

  func testVehiclesNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetVehiclesFailure(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    do {
      _ = try await connect.vehicles()
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await fulfillment(of: [expectation], timeout: kDefaultTestTimeout)
  }

  func testVehiclesAuthRequiredAuthFailure() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetAuth0InitialStateFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    do {
      _ = try await connect.vehicles()
    } catch {
      expectation.fulfill()
      XCTAssertEqual(PorscheConnectError.AuthFailure, error as! PorscheConnectError)
    }

    await fulfillment(of: [expectation], timeout: kDefaultTestTimeout)
  }

  // MARK: - Private functions

  private func assertVehicle(_ vehicle: Vehicle) {
    XCTAssertEqual("VIN12345", vehicle.vin)
    XCTAssertEqual("Porsche Taycan 4S", vehicle.modelDescription)
    XCTAssertEqual("A Test Model Type", vehicle.modelType)
    XCTAssertEqual("2021", vehicle.modelYear)
  }
}
