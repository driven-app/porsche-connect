import Foundation

// MARK: - Enums

public enum Environment: String {
  case production, test

  public var countryCode: String {
    switch self {
    case .production:
      return "de"
    case .test:
      return "ie"
    }
  }

  public var languageCode: String {
    switch self {
    case .production:
      return "de"
    case .test:
      return "en"
    }
  }

  public var regionCode: String {
    switch self {
    case .production:
      return "de/de_DE"
    case .test:
      return "ie/en_IE"
    }
  }
}

public enum Application {
  case api, carControl

  public var clientId: String {
    switch self {
    case .api:
      return "4mPO3OE5Srjb1iaUGWsbqKBvvesya8oA"
    case .carControl:
      return "Ux8WmyzsOAGGmvmWnW7GLEjIILHEztAs"
    }
  }

  public var redirectURL: URL {
    switch self {
    case .api:
      return URL(string: "https://my.porsche.com/core/de/de_DE")!
    case .carControl:
      return URL(string: "https://my.porsche.com/myservices/auth/auth.html")!
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
  var auths: [Application: PorscheAuth] = Dictionary()

  let networkClient = NetworkClient()
  let networkRoutes: NetworkRoutes
  let password: String
  let codeChallenger = CodeChallenger()

  // MARK: - Init & configuration

  public init(username: String, password: String, environment: Environment = .production) {
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

  func buildHeaders(accessToken: String, apiKey: String, countryCode: String, languageCode: String)
    -> [String: String]
  {
    return [
      "Authorization": "Bearer \(accessToken)",
      "apikey": apiKey,
      "x-vrs-url-country": countryCode,
      "x-vrs-url-language": "\(languageCode)_\(countryCode.uppercased())",
    ]
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
