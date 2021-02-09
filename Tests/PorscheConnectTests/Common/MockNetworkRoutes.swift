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
    return ["access_token": "Kpjg2m1ZXd8GM0pvNIB3jogWd0o6",
            "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ",
            "token_type": "Bearer",
            "expires_in":7199]
  }
  
  private func mockVehiclesResponse() -> [Dictionary<String, Any>] {
    return [
      ["vin": "VIN12345",
       "modelDescription": "Porsche Taycan 4S",
       "modelType": "A Test Model Type",
       "modelYear": "2021",
       "exteriorColorHex": "#47402e",
       "attributes": [["name": "licenseplate", "value": "Porsche Taycan"]]
      ]
    ]
  }
}
