import Foundation
import Ambassador

final class MockNetworkRoutes {

  // MARK: - Properties
  
  private static let getHelloWorldPath = "/hello_world.json"

  public var recorder = [Dictionary<String, Any>]()
  
  // MARK: - Mock Routes
  
  func mockGetHelloWorldSuccessful(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 200) { (req) -> Any in
      self.recorder.append(req)
      return self.mockHelloWorldResponse()
    }
  }
  
  func mockGetHelloWorldFailure(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 401, statusMessage: "unauthorized")
  }
  
  // MARK: - Mock Responses
  
  private func mockHelloWorldResponse() -> [String: Any] {
    return ["message": "Hello World!"]
  }
}
