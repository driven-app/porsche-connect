import Foundation
import Network
import Embassy
import Ambassador

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
