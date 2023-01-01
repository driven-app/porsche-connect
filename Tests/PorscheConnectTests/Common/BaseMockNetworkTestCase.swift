import Foundation
import XCTest
import Ambassador

@testable import PorscheConnect

class BaseMockNetworkTestCase: XCTestCase {

  // MARK: – Properties

  var router = Router()
  var mockServer: MockServer!

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    mockServer = MockServer(router: router)
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }

  override func tearDown() {
    super.tearDown()
    mockServer.server.stopAndWait()
    print("Mock Web Server at port \(mockServer.server.port): stopped")
    mockServer.loop.stop()
    router = Router()
  }
}
