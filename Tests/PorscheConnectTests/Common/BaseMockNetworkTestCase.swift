import Foundation
import XCTest
import Ambassador

@testable import PorscheConnect

class BaseMockNetworkTestCase: XCTestCase {

  // MARK: – Properties

  var router = Router()
  var mockServer: MockServer?

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    mockServer = MockServer(router: router)
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }

  override func tearDown() {
    super.tearDown()
    if let mockServer = mockServer {
      mockServer.server.stop()
      router = Router()
    }
  }
}
