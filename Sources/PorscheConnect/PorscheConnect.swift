import Foundation

// MARK: - Enums

public enum Environment: String, CaseIterable {
  case Ireland, Germany, Test
    
  public var countryCode: String {
    switch self {
    case .Ireland:
      return "ie/en_GB"
    case .Germany:
      return "de/de_DE"
    case .Test:
      return "ie/en_IE"
    }
  }
}

// MARK: - Structs

public struct NetworkRoutes {
  let environment: Environment
  
  func loginAuthURL() -> URL {
    switch environment {
    case .Ireland, .Germany:
      return URL(string: "https://login.porsche.com/auth/api/v1/\(environment.countryCode)/public/login")!
    case .Test:
      return URL(string: "https://localhost:\(kTestServerPort)/auth/api/v1/\(environment.countryCode)/public/login")!
    }
  }
}

struct PorscheConnect {
  public typealias Success = ((Any?, HTTPURLResponse?, ResponseJson?) -> Void)
  public typealias Failure = ((Error, HTTPURLResponse?) -> Void)
  
  let environment: Environment
  let username: String
  
  private let networkClient = NetworkClient()
  private let networkRoutes: NetworkRoutes
  private let password: String
  
  // MARK: - Init & Configuration
  
  public init(environment: Environment, username: String, password: String) {
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
    self.username = username
    self.password = password
  }
  
  public func auth(success: Success? = nil, failure: Failure? = nil) {
    let loginBody = ["username": username, "password": password, "keeploggedin": "false", "sec": "", "resume": "", "thirdPartyId": "", "state": ""]
    
    networkClient.post(String.self, url: networkRoutes.loginAuthURL(), body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form) { (body, response, error, responseJson) in
      handleResponse(body: body, response: response, error: error, json: responseJson, success: success, failure: failure)
    }
  }
  
  // MARK: - Internal

  fileprivate func handleResponse(body: Any?, response: HTTPURLResponse?, error: Error?, json: ResponseJson?, success: Success?, failure: Failure?) {
    DispatchQueue.main.async {
      if let failure = failure, let error = error {
        failure(error, response)
      } else if let success = success {
        success(body, response, json)
      }
    }
  }
  
}
