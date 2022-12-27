import Foundation
import XCTest

@testable import PorscheConnect

class BaseMockNetworkTestCase: XCTestCase {

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }
}
