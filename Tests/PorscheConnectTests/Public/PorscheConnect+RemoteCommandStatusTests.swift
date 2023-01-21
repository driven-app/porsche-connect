import XCTest
import func XCTAsync.XCTAssertFalse

@testable import PorscheConnect

final class PorscheConnectRemoteCommandStatuslTests: BaseMockNetworkTestCase {

  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .carControl
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

  // MARK: - Honk and Flash Tests

  func testRemoteCommandHonkAndFlashStatusInProgressAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusInProgress(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandHonkAndFlashStatusSuccessAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusSuccess(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandHonkAndFlashStatusFailureAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Toggle Direct Charging Tests

  func testRemoteCommandToggleDirectChargingStatusInProgressAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusInProgress(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectChargingStatusSuccessAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusSuccess(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectChargingStatusFailureAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Toggle Direct Climatisation Tests

  func testRemoteCommandToggleDirectClimatisationStatusInProgressAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectClimatisation)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectClimatisationRemoteCommandStatusInProgress(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectClimatisationStatusSuccessAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectClimatisation)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectClimatisationRemoteCommandStatusSuccess(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectClimatisationStatusFailureAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectClimatisation)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectClimatisationRemoteCommandStatusFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  // MARK: - Lock Tests

  func testRemoteCommandLockStatusInProgressAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusInProgress(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandLockStatusSuccessfulAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusSuccess(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandLockStatusFailureAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Unlock Tests

  func testRemoteCommandUnlockStatusInProgressAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusInProgress(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandUnlockStatusSuccessfulAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusSuccess(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandUnlockStatusFailureAuthRequiredSuccessful() async throws {
    try await connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusFailure(router: router)

    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))

    let result = try! await connect.checkStatus(vin: vin, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}
