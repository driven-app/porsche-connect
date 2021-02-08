import XCTest
@testable import PorscheConnect

final class PorscheConnectTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(environment: .Test, username: "homer.simpson@icloud.example", password: "Duh!")
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }
  
  func testConstruction() {
    XCTAssertNotNil(self.connect)
    XCTAssertEqual(Environment.Test, self.connect.environment)
    XCTAssertEqual("homer.simpson@icloud.example", self.connect.username)
    XCTAssertFalse(self.connect.authorized)
  }
  
  func testEnvironmentIreland() {
    let environment = Environment.Ireland
    XCTAssertNotNil(environment)
    XCTAssertEqual("ie/en_GB", environment.regionCode)
    XCTAssertEqual("en", environment.languageCode)
    XCTAssertEqual("ie", environment.countryCode)
  }
  
  func testEnvironmentGermany() {
    let environment = Environment.Germany
    XCTAssertNotNil(environment)
    XCTAssertEqual("de/de_DE", environment.regionCode)
    XCTAssertEqual("de", environment.languageCode)
    XCTAssertEqual("de", environment.countryCode)
  }
  
  func testEnvironmentTest() {
    let environment = Environment.Test
    XCTAssertNotNil(environment)
    XCTAssertEqual("ie/en_IE", environment.regionCode)
    XCTAssertEqual("en", environment.languageCode)
    XCTAssertEqual("ie", environment.countryCode)
  }
  
  func testApplicationClientIdPortal() {
    let application = Application.Portal
    XCTAssertNotNil(application)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", application.clientId)
  }
  
  func testApplicationRedirectURLPortal() {
    let application = Application.Portal
    XCTAssertNotNil(application)
    XCTAssertEqual(URL(string: "https://my-static02.porsche.com/static/cms/auth.html")!, application.redirectURL)
  }
  
  func testNetworkRoutesIreland() {
    let networkRoute = NetworkRoutes(environment: .Ireland)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/ie/en_GB/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)
  }
  
  func testNetworkRoutesGermany() {
    let networkRoute = NetworkRoutes(environment: .Germany)
    XCTAssertEqual(URL(string: "https://login.porsche.com/auth/api/v1/de/de_DE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "https://login.porsche.com/as/token.oauth2")!, networkRoute.apiTokenURL)
  }
  
  func testNetworkRoutesTest() {
    let networkRoute = NetworkRoutes(environment: .Test)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/auth/api/v1/ie/en_IE/public/login")!, networkRoute.loginAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/authorization.oauth2")!, networkRoute.apiAuthURL)
    XCTAssertEqual(URL(string: "http://localhost:\(kTestServerPort)/as/token.oauth2")!, networkRoute.apiTokenURL)
  }
  
  func testAuthLoggerIsDefined() {
    XCTAssertNotNil(AuthLogger)
  }
  
  func testRequestTokenSuccessful() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized)
    XCTAssertNil(self.connect.auth)
    
    self.connect.auth { (body, response, responseJson) in
      expectation.fulfill()
      XCTAssertNotNil(body)
      XCTAssertNotNil(response)
      XCTAssertNil(responseJson)
      
      XCTAssert(self.connect.authorized)
      
      self.assertCookiesPresent()
      
      let porscheAuth = body as! PorscheAuth
      XCTAssertNotNil(porscheAuth)
      XCTAssertEqual("QycHMMWhUjsEVNUxzLgM92XGIN17", porscheAuth.accessToken)
      XCTAssertEqual("eyQhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ", porscheAuth.idToken)
      XCTAssertEqual("Bearer", porscheAuth.tokenType)
      XCTAssertEqual(7199, porscheAuth.expiresIn)
      
      XCTAssertNotNil(self.connect.auth)
      XCTAssertEqual("QycHMMWhUjsEVNUxzLgM92XGIN17", self.connect.auth!.accessToken)
      XCTAssertEqual("eyQhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ", self.connect.auth!.idToken)
      XCTAssertEqual("Bearer", self.connect.auth!.tokenType)
      XCTAssertEqual(7199, self.connect.auth!.expiresIn)
    }
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testRequestTokenFailureAtLoginToRetrieveCookies() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthFailure(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized)
    XCTAssertNil(self.connect.auth)
    
    self.connect.auth(failure: { (error, response) in
      expectation.fulfill()
      
      XCTAssertFalse(self.connect.authorized)
      XCTAssertNil(self.connect.auth)
      
      self.assertCookiesNotPresent()
    })
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testRequestTokenFailureAtGetApiAuthCode() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockGetApiAuthFailure(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized)
    XCTAssertNil(self.connect.auth)
    
    self.connect.auth(failure: { (error, response) in
      expectation.fulfill()
      
      XCTAssertFalse(self.connect.authorized)
      XCTAssertNil(self.connect.auth)
      
      self.assertCookiesPresent()
    })
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testRequestTokenFailureAtGetApiAuthToken() {
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: BaseMockNetworkTestCase.router)
    mockNetworkRoutes.mockPostApiTokenFailure(router: BaseMockNetworkTestCase.router)
    
    XCTAssertFalse(self.connect.authorized)
    XCTAssertNil(self.connect.auth)
    
    self.connect.auth(failure: { (error, response) in
      expectation.fulfill()
      
      XCTAssertFalse(self.connect.authorized)
      XCTAssertNil(self.connect.auth)
      
      self.assertCookiesPresent()
    })
    
    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  //  func testVehiclesSuccessful() {
  //    let expectation = self.expectation(description: "Network Expectation")
  //
  //    XCTAssertFalse(self.connect.authorized)
  //    XCTAssertNil(self.connect.auth)
  //
  //    self.connect.vehicles(success: { (vehicles, response, responseJson) in
  //      expectation.fulfill()
  //
  //    })
  //
  //    waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  //  }
  
  // MARK: - Private functions
  
  private func assertCookiesNotPresent() {
    let cookies = HTTPCookieStorage.shared.cookies!
    XCTAssertEqual(0, cookies.count)
  }
  
  private func assertCookiesPresent() {
    let cookies = HTTPCookieStorage.shared.cookies!
    XCTAssertEqual(1, cookies.count)
    
    let cookie = cookies.first!
    XCTAssertEqual("CIAM.status", cookie.name)
    XCTAssertEqual("mockValue", cookie.value)
  }
}
