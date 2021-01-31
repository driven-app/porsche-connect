import Foundation

// MARK: - Enums

public enum Environment: String, CaseIterable {
  case Ireland, Germany, Test
    
  public func baseURL() -> URL {
    switch self {
    case .Ireland:
      return URL(string: "https://api.porsche.com")!
    case .Germany:
      return URL(string: "https://api.porsche.com")!
    case .Test:
      return URL(string: "https://api.porsche.example")!
    }
  }
  
  private func countryCode() -> String {
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
  let environment: Environment
  let username: String
  let password: String
  
  // MARK: - Init & Configuration
  
  public init(environment: Environment, username: String, password: String) {
    self.environment = environment
    self.username = username
    self.password = password
  }
  
  public func auth() {
    let loginBody = ["username": username, "password": password, "keeploggedin": false, "sec": "", "resume": "", "thirdPartyId": "", "state": ""] as [String : Any]
    
    
  }
}
