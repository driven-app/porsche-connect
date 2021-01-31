import Foundation
@testable import PorscheConnect
import XCTest

import Embassy
import Ambassador

class BaseMockNetworkTestCase: XCTestCase {
  
  // MARK: - Properties
  
  let router = Router()
  let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
  var server: HTTPServer!
  
  override func setUp() {
    super.setUp()
    setupMockWebServer()
  }
  
  override func tearDown() {
    super.tearDown()
    tearDownMockWebServer()
  }
  
  // MARK: - Private
  
  private func setupMockWebServer() {
    let port = randomMockServerPortForProcess()
    server = DefaultHTTPServer(eventLoop: loop, port: port, app: router.app)
    
    try! server.start()
    
    if let server = server as? DefaultHTTPServer {
      print("Started Mock Web Server at port \(server.port)")
    }
    
    DispatchQueue.global().async {
      self.loop.runForever()
    }
  }
  
  private func tearDownMockWebServer() {
    server.stopAndWait()
    loop.stop()
  }
}
