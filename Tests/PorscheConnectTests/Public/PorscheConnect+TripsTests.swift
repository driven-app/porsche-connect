import XCTest
import func XCTAsync.XCTAssertFalse
import func XCTAsync.XCTAssertTrue

@testable import PorscheConnect

final class PorscheConnectTripTests: BaseMockNetworkTestCase {
  
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
  
  func testShortTermTripsNoAuthRequiredSuccessful() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetShortTermTripsSuccessful(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    let results = try! await connect.trips(vin: vin)

    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    XCTAssertNotNil(results)
    XCTAssertNotNil(results.trips)
    XCTAssertEqual(1, results.trips!.count)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testShortTermTripsNoAuthRequiredFailure() async {
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetShortTermTripsFailure(router: router)

    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))

    do {
      _ = try await connect.trips(vin: vin)
    } catch {
      expectation.fulfill()
      XCTAssertEqual(HttpStatusCode.BadRequest, error as! HttpStatusCode)
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}
