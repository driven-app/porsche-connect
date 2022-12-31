import Ambassador
import Embassy
import Foundation
import Network

class MockServer {
  let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
  var server: DefaultHTTPServer!

  public init(router: Router) {
    setupMockWebServer(router: router)
  }

  // MARK: - Private

  private func setupMockWebServer(router: Router) {
    introduceDelayIfConfigured()

    server = DefaultHTTPServer(eventLoop: loop, port: kTestServerPort, app: router.app)

    try! server.start()

    print("Mock Web Server at port \(server.port): starting")

    DispatchQueue.global().async {
      self.loop.runForever()
    }

    waitForServer()
  }

  private func waitForServer() {
    let semaphore = DispatchSemaphore(value: 0)
    let connection = NWConnection(
      host: "localhost", port: NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(server.port))!,
      using: .tcp)

    connection.start(queue: .init(label: "Socket Q"))
    connection.stateUpdateHandler = { (newState) in
      switch newState {
      case .ready:
        semaphore.signal()
      default:
        break
      }
    }

    semaphore.wait()
    print("Mock Web Server at port \(server.port): started")
  }

  private func introduceDelayIfConfigured() {
    if let delayServer = ProcessInfo.processInfo.environment["DELAY_MOCK_SERVER_START"] {
      print("Delaying Mock Server start for \(delayServer) seconds")
      Thread.sleep(forTimeInterval: (delayServer as NSString).doubleValue)
    }
  }
}
