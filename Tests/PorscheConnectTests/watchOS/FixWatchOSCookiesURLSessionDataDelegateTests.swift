import XCTest
@testable import PorscheConnect

final class FixWatchOSCookiesURLSessionDataDelegateTests: XCTestCase {

  var delegate: FixWatchOSCookiesURLSessionDataDelegate!
  override func setUpWithError() throws {
    delegate = FixWatchOSCookiesURLSessionDataDelegate()
  }

  override func tearDownWithError() throws {
    delegate = nil
  }

  // MARK: - Defaults

  func testInterceptCookiesIsOffByDefault() throws {
    let delegate = FixWatchOSCookiesURLSessionDataDelegate()
    XCTAssertFalse(delegate.interceptCookies)
  }

  // MARK: - Cookie injection

  func testCookieGetsInjectedWhenInterceptCookiesIsOn() async throws {
    // Given
    let delegate = FixWatchOSCookiesURLSessionDataDelegate()
    delegate.interceptCookies = true

    // When
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let url = URL(string: "https://login.porsche.com/")!
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request)
    let response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: nil, headerFields: [
      "Set-Cookie": "CIAM.status=loggedinuntil12345; Domain=.porsche.com; Path=/; Secure; SameSite=None"
    ])!
    let newRequest = await delegate.urlSession(session, task: task, willPerformHTTPRedirection: response, newRequest: request)

    // Then
    let cookie = try XCTUnwrap(newRequest?.allHTTPHeaderFields?["Cookie"])
    XCTAssertEqual(cookie, "CIAM.status=loggedinuntil12345")
  }

  func testCookieDoesNotGetInjectedWhenInterceptCookiesIsOff() async throws {
    // Given
    let delegate = FixWatchOSCookiesURLSessionDataDelegate()
    delegate.interceptCookies = false

    // When
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let url = URL(string: "https://login.porsche.com/")!
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request)
    let response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: nil, headerFields: [
      "Set-Cookie": "CIAM.status=loggedinuntil12345; Domain=.porsche.com; Path=/; Secure; SameSite=None"
    ])!
    let newRequest = await delegate.urlSession(session, task: task, willPerformHTTPRedirection: response, newRequest: request)

    // Then
    XCTAssertNil(newRequest?.allHTTPHeaderFields?["Cookie"])
  }
}
