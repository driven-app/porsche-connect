import Foundation
import XCTest

#if !os(macOS)
import UIKit
#endif

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

// MARK: - Helper functions

public func randomMockServerPortForProcess() -> Int {
  let fileUrl = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(deviceName())-port.txt")
  
  if !FileManager.default.fileExists(atPath: fileUrl.path) {
    let port = String(Int.random(in: 3000 ... 9999))
    try! port.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
  }
  
  let port = try! String(contentsOf: fileUrl, encoding: .utf8)
  
  return Int(port)!
}

private func deviceName() -> String {
  #if os(iOS) || os(watchOS) || os(tvOS)
  return UIDevice.current.name
  #elseif os(macOS)
  return Host.current().name ?? "device"
  #endif
}
