import Foundation
import Ambassador

final class MockNetworkRoutes {
  
  // MARK: - Properties
  
  private static let getHelloWorldPath = "/hello_world.json"
  private static let getApiAuthPath = "/as/authorization.oauth2"
  private static let getVehiclesPath = "/core/api/v3/ie/en_IE/vehicles"
    
  private static let postLoginAuthPath = "/auth/api/v1/ie/en_IE/public/login"
  private static let postApiTokenPath = "/as/token.oauth2"
  
  // MARK: - Hello World
  
  func mockGetHelloWorldSuccessful(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 200) { (req) -> Any in
      return self.mockHelloWorldResponse()
    }
  }
  
  func mockGetHelloWorldFailure(router: Router) {
    router[MockNetworkRoutes.getHelloWorldPath] = JSONResponse(statusCode: 401, statusMessage: "unauthorized")
  }
  
  // MARK: - Post Login Auth
  
  func mockPostLoginAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.postLoginAuthPath] = DataResponse(statusCode: 200, statusMessage: "ok", headers: [("Set-Cookie", "CIAM.status=mockValue")])
  }
  
  func mockPostLoginAuthFailure(router: Router) {
    router[MockNetworkRoutes.postLoginAuthPath] = DataResponse(statusCode: 400, statusMessage: "bad request")
  }
  
  // MARK: - Get Api Auth
  
  func mockGetApiAuthSuccessful(router: Router) {
    router[MockNetworkRoutes.getApiAuthPath] = DataResponse(statusCode: 200, statusMessage: "ok", headers: [("cdn-original-uri", "/static/cms/auth.html?code=fqFQlQSUfNkMGtMLj0zRK0RriKdPySGVMmVXPAAC")])
  }
  
  func mockGetApiAuthFailure(router: Router) {
    router[MockNetworkRoutes.getApiAuthPath] = DataResponse(statusCode: 400, statusMessage: "bad request")
  }
  
  // MARK: - Post Api Token
  
  func mockPostApiTokenSuccessful(router: Router) {
    router[MockNetworkRoutes.postApiTokenPath] = JSONResponse(statusCode: 200) { (req) -> Any in
      return self.mockApiTokenResponse()
    }
  }
  
  func mockPostApiTokenFailure(router: Router) {
    router[MockNetworkRoutes.postApiTokenPath] = DataResponse(statusCode: 400, statusMessage: "bad request")
  }
  
  // MARK: - Get Vehicles
  
  func mockGetVehiclesSuccessful(router: Router) {
    router[MockNetworkRoutes.getVehiclesPath] = JSONResponse(statusCode: 200) { (req) -> Any in
      return self.mockVehiclesResponse()
    }
  }
  
  // MARK: - Mock Responses
  
  private func mockHelloWorldResponse() -> Dictionary<String, Any> {
    return ["message": "Hello World!"]
  }
  
  private func mockApiTokenResponse() -> Dictionary<String, Any> {
    return ["access_token": "QycHMMWhUjsEVNUxzLgM92XGIN17",
            "id_token": "eyQhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ",
            "token_type": "Bearer",
            "expires_in":7199]
  }
  
  private func mockVehiclesResponse() -> [Dictionary<String, String>] {
    return [["vin": "VIN12345",
            "model": "eyQhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ",
            "modelDescription": "A Test Description",
            "modelType": "A Test Model Type",
            "modelYear": "2021"]]
  }
}
