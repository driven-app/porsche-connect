import Foundation

// MARK: - Enums

public enum Environment: String {
  case Ireland, Germany, Test
  
  public var countryCode: String {
    switch self {
    case .Ireland:
      return "ie"
    case .Germany:
      return "de"
    case .Test:
      return "ie"
    }
  }
  
  public var languageCode: String {
    switch self {
    case .Ireland:
      return "en"
    case .Germany:
      return "de"
    case .Test:
      return "en"
    }
  }
  
  public var regionCode: String {
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

public enum Application {
  case Portal, CarControl
  
  public var clientId: String {
    switch self {
    case .Portal:
      return "TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp"
    case .CarControl:
      return "gZLSI7ThXFB4d2ld9t8Cx2DBRvGr1zN2"
    }
  }
  
  public var redirectURL: URL {
    switch self {
    case .Portal:
      return URL(string: "https://my-static02.porsche.com/static/cms/auth.html")!
    case .CarControl:
      return URL(string: "https://connect-portal.porsche.com/myservices/auth/auth.html")!
    }
  }
}

public enum PorscheConnectError: Error {
  case AuthFailure
  case NoResult
}


// MARK: - Porsche Connect

public class PorscheConnect {
  
  let environment: Environment
  let username: String
  var auths: Dictionary<Application, PorscheAuth> = Dictionary()
  
  let networkClient = NetworkClient()
  let networkRoutes: NetworkRoutes
  let password: String
  let codeChallenger = CodeChallenger(length: 40)
  
  // MARK: - Init & configuration
  
  public init(username: String, password: String, environment: Environment = .Germany) {
    self.username = username
    self.password = password
    self.environment = environment
    self.networkRoutes = NetworkRoutes(environment: environment)
  }
  
  // MARK: - Common functions
  
  func authorized(application: Application) -> Bool {
    guard let auth = auths[application] else {
      return false
    }

    return !auth.expired
  }
  
  func buildHeaders(accessToken: String, apiKey: String, countryCode: String, languageCode: String) -> Dictionary<String, String> {
    return ["Authorization": "Bearer \(accessToken)",
            "apikey": apiKey,
            "x-vrs-url-country": countryCode,
            "x-vrs-url-language": "\(languageCode)_\(countryCode.uppercased())"]
  }
  
  func authIfRequired(application: Application) async throws {
    if !authorized(application: application) {
      do {
      _ = try await auth(application: application)
      } catch {
        throw PorscheConnectError.AuthFailure
      }
    }
  }
}
