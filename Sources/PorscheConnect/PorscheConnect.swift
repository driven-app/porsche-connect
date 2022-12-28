import Foundation

// MARK: - Enums

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

  public init(username: String, password: String, environment: Environment = .germany) {
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

  func buildHeaders(accessToken: String, apiKey: String, countryCode: CountryCode, languageCode: LanguageCode)
    -> [String: String]
  {
    return [
      "Authorization": "Bearer \(accessToken)",
      "apikey": apiKey,
      "x-vrs-url-country": countryCode.rawValue,
      "x-vrs-url-language": "\(languageCode.rawValue)_\(countryCode.rawValue.uppercased())",
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
