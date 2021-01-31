import Foundation

// MARK: - Enums

public enum Environment: String, CaseIterable {
  case Ireland, Germany, Test
  
  public func loginBaseURL() -> URL {
    switch self {
    case .Ireland, .Germany, .Test:
      return URL(string: "https://login.porsche.com")!
    }
  }
  
  public func loginEndpoint() -> String {
    switch self {
    case .Ireland, .Germany, .Test:
      return "/auth/api/v1/\(countryCode)/public/login"
    }
  }
  
  private var countryCode: String {
    switch self {
    case .Ireland:
      return "ie/en_GB"
    case .Germany:
      return "de/de_DE"
    case .Test:
      return "ie/en_GB"
    }
  }
}

// MARK: - Structs

struct PorscheConnect {
  public typealias Success = ((Any?, HTTPURLResponse?, ResponseJson?) -> Void)
  public typealias Failure = ((Error, HTTPURLResponse?) -> Void)
  
  let environment: Environment
  let username: String
  
  private let networkClient = NetworkClient()
  private let password: String
  
  // MARK: - Init & Configuration
  
  public init(environment: Environment, username: String, password: String) {
    self.environment = environment
    self.username = username
    self.password = password
  }
  
  public func auth(success: Success? = nil, failure: Failure? = nil) {
    let loginBody = ["username": username, "password": password, "keeploggedin": "false", "sec": "", "resume": "", "thirdPartyId": "", "state": ""]
    
    networkClient.post(String.self, baseURL: environment.loginBaseURL(), endpoint: environment.loginEndpoint(), body: buildPostFormBodyFrom(dictionary: loginBody), contentType: .form) { (porscheAuth, response, error, responseJson) in
      ""
    }
  }
}

