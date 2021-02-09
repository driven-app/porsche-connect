import Foundation
import Network
import XCTest

import Embassy
import Ambassador

@testable import PorscheConnect

class BaseMockNetworkTestCase: XCTestCase {
  
  // MARK: - Properties
  
  static let router = Router()
  static let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
  static var server: DefaultHTTPServer!
  
  // MARK: - Once Lifecycle
  
  override class func setUp() {
    super.setUp()
    setupMockWebServer()
  }
  
  override class func tearDown() {
    super.tearDown()
    tearDownMockWebServer()
  }
  
  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }
    
  // MARK: - Private
  
  private class func setupMockWebServer() {
    server = DefaultHTTPServer(eventLoop: loop, port: kTestServerPort, app: router.app)
    
    try! server.start()
    
    print("Mock Web Server at port \(server.port): starting")
    
    DispatchQueue.global().async {
      loop.runForever()
    }
    
    waitForServer()
  }
  
  private class func tearDownMockWebServer() {
    server.stopAndWait()
    loop.stop()
    print("Mock Web Server at port \(server.port): stopped")
  }
  
  private class func waitForServer() {
    let semaphore = DispatchSemaphore(value: 0)
    let connection = NWConnection(host: "localhost", port: NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(server.port))!, using: .tcp)
    
    connection.start(queue: .init(label: "Socket Q"))
    connection.stateUpdateHandler = { (newState) in
      switch (newState) {
      case .ready:
        semaphore.signal()
      default:
        break
      }
    }
    
    semaphore.wait()
    print("Mock Web Server at port \(server.port): started")
  }
  
}
