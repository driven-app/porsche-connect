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
  
  // MARK: - Lifecycle
  
  override class func setUp() {
    super.setUp()
    setupMockWebServer()
  }
  
  override class func tearDown() {
    super.tearDown()
    tearDownMockWebServer()
  }
  
  // MARK: - Helpers
  
  func cookiesFrom(response: HTTPURLResponse) -> [HTTPCookie] {
    guard let allHeaderFields = response.allHeaderFields as? Dictionary<String, String> else {
      return []
    }
    
    return HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: response.url!)
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
