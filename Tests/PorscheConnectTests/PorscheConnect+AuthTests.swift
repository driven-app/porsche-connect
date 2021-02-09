import XCTest
@testable import PorscheConnect

final class PorscheConnectAuthTests: BaseMockNetworkTestCase {
 
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Setup
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
  }
  
  // MARK: - Tests
  
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
