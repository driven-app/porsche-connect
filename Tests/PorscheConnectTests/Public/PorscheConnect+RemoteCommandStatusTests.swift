import XCTest

@testable import PorscheConnect

final class PorscheConnectRemoteCommandStatuslTests: BaseMockNetworkTestCase {

  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  let application: OAuthApplication = .carControl
  let vehicle = Vehicle(vin: "A1234")

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
    connect.authStorage.storeAuthentication(token: OAuthToken(authResponse: kTestPorschePortalAuth),
                                            for: application.clientId)
  }

  // MARK: - Honk and Flash Tests

  func testRemoteCommandHonkAndFlashStatusInProgressAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusInProgress(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandHonkAndFlashStatusSuccessAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusSuccess(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandHonkAndFlashStatusFailureAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(id: "999", lastUpdated: Date(), remoteCommand: .honkAndFlash)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetHonkAndFlashRemoteCommandStatusFailure(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Toggle Direct Charging Tests

  func testRemoteCommandToggleDirectChargingStatusInProgressAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusInProgress(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectChargingStatusSuccessAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusSuccess(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandToggleDirectChargingStatusFailureAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .toggleDirectCharge)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetToggleDirectChargingRemoteCommandStatusFailure(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Lock Tests

  func testRemoteCommandLockStatusInProgressAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusInProgress(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandLockStatusSuccessfulAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusSuccess(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandLockStatusFailureAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusFailure(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Unlock Tests

  func testRemoteCommandUnlockStatusInProgressAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusInProgress(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("IN_PROGRESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.inProgress, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandUnlockStatusSuccessfulAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusSuccess(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertEqual("SUCCESS", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.success, result.status!.remoteStatus)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRemoteCommandUnlockStatusFailureAuthRequiredSuccessful() async {
    connect.authStorage.storeAuthentication(token: nil, for: application.clientId)
    let remoteCommand = RemoteCommandAccepted(requestId: "999", remoteCommand: .lock)
    let expectation = expectation(description: "Network Expectation")

    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: router)
    mockNetworkRoutes.mockGetLockUnlockRemoteCommandStatusFailure(router: router)

    XCTAssertFalse(connect.authorized(application: application))

    let result = try! await connect.checkStatus(vehicle: vehicle, remoteCommand: remoteCommand)

    expectation.fulfill()
    XCTAssertNotNil(result)
    XCTAssertNotNil(result.status)
    XCTAssertEqual("FAILURE", result.status!.status)
    XCTAssertEqual(RemoteCommandStatus.RemoteStatus.failure, result.status!.remoteStatus)
    XCTAssertEqual("INTERNAL", result.status!.errorType)

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
}
