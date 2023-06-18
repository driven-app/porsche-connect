import XCTest
import func XCTAsync.XCTAssertFalse
import func XCTAsync.XCTAssertTrue

@testable import PorscheConnect

final class PorscheConnectAuthTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties

  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()

  // MARK: - Setup

  override func setUp() {
    super.setUp()
    connect = PorscheConnect(
      username: "homer.simpson@icloud.example", password: "Duh!", environment: .test)
  }
  
  // MARK: - Tests

  func testRequestTokenSuccessful() async throws {
    let application: OAuthApplication = .api
    let expectation = expectation(description: "Network Expectation")
    mockNetworkRoutes.mockGetAuth0InitialStateSuccessful(router: router)
    mockNetworkRoutes.mockPostLoginDetailsAuth0Successful(router: router)
    mockNetworkRoutes.mockGetAuth0CallbackSuccessful(router: router)
    mockNetworkRoutes.mockGetAuth0ResumeAuthSuccessful(router: router)
    mockNetworkRoutes.mockPostAuth0AccessTokenSuccessful(router: router)
    
    await XCTAsync.XCTAssertFalse(await connect.authorized(application: application))
    let porscheAuth = try await connect.auth(application: application)
    expectation.fulfill()
    await XCTAsync.XCTAssertTrue(await connect.authorized(application: application))
    
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", porscheAuth.accessToken)
    XCTAssertEqual(
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ",
      porscheAuth.idToken)
    XCTAssertEqual("Bearer", porscheAuth.tokenType)
    XCTAssertEqual("openid", porscheAuth.scope)
    XCTAssertGreaterThan(porscheAuth.expiresAt, Date())
  
    let auth = await connect.authStorage.authentication(for: application.clientId)
    let portalAuth = try XCTUnwrap(auth)

    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", portalAuth.accessToken)
    XCTAssertEqual(
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ",
      portalAuth.idToken)
    XCTAssertEqual("Bearer", portalAuth.tokenType)
    XCTAssertGreaterThan(porscheAuth.expiresAt, Date())
    
    await fulfillment(of: [expectation], timeout: kDefaultTestTimeout+kSleepDurationInSecs)
  }
}
