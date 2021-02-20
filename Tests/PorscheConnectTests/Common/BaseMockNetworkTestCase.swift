import Foundation
import Network
import XCTest

import Embassy
import Ambassador

@testable import PorscheConnect

class MockServer {
  static let shared = MockServer()

  let router = Router()
  let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
  var server: DefaultHTTPServer!
  
  private init() {
    setupMockWebServer()
  }
  
  // MARK: - Private
  
  private func setupMockWebServer() {
    server = DefaultHTTPServer(eventLoop: loop, port: kTestServerPort, app: router.app)
    
    try! server.start()
    
    print("Mock Web Server at port \(server.port): starting")
    
    DispatchQueue.global().async {
      self.loop.runForever()
    }
    
    waitForServer()
  }
  
  private func tearDownMockWebServer() {
    server.stopAndWait()
    loop.stop()
    print("Mock Web Server at port \(server.port): stopped")
  }
  
  private func waitForServer() {
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

class BaseMockNetworkTestCase: XCTestCase {
      
  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
  }
    
}
