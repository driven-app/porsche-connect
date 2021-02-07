import Foundation
import Ambassador

final class MockNetworkRoutes {
  
  // MARK: - Properties
  
  private static let getHelloWorldPath = "/hello_world.json"
  private static let getApiAuthPath = "/as/authorization.oauth2"
  
  private static let postLoginAuthPath = "/auth/api/v1/ie/en_IE/public/login"
  
  // MARK: - Mock Routes
  
  func mockGetHelloWorldSuccessful(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 200) { (req) -> Any in
      return self.mockHelloWorldResponse()
    }
  }
  
  func mockGetHelloWorldFailure(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 401, statusMessage: "unauthorized")
  }
  
  func mockGetApiAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.getApiAuthPath] = DataResponse(statusCode: 200, statusMessage: "ok", headers: [("Set-Cookie", "CIAM.status=mockValue")])
  }
  
  func mockPostLoginAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.postLoginAuthPath] = DataResponse(statusCode: 200, statusMessage: "ok")
  }
  
  // MARK: - Mock Responses
  
  private func mockHelloWorldResponse() -> Dictionary<String, Any> {
    return ["message": "Hello World!"]
  }
}
